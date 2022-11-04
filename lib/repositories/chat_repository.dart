import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/config/data_mock.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/chat_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:validators/sanitizers.dart";

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository(
    this.firestore,
    this.auth,
  );

  final StreamController<List<Map<String, dynamic>>> _messagesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get messages => _messagesController.stream;

  Future<void> load(Map<String, dynamic> data) async {
    if (!data.containsKey("groupId")) {
      throw ArgumentError("groupId is required");
    }

    info(
      "Loading messages for group",
      data: data,
    );

    for (var group in groupsList) {
      if (group["uid"] == data["groupId"]) {
        _messagesController.add(group["messages"]);
      }
    }
  }

  Future<Map<String, dynamic>> post(Map<String, dynamic> data) async {
    final User? user = auth.currentUser;

    if (user == null) {
      throw const AuthenticationException(
        "User is not authenticated",
        "unauthenticated",
      );
    }

    if (!data.containsKey("message") || trim(data["message"]).isEmpty) {
      throw const ChatException(
        "message is required",
        "message_required",
      );
    }

    if (!data.containsKey("recipient") ||
        !data["recipient"].containsKey("uid") ||
        trim(data["recipient"]["uid"]).isEmpty) {
      throw const ChatException(
        "recipient is required",
        "recipient_required",
      );
    }

    final DateTime now = DateTime.now();

    if (!data.containsKey("groupId") || data["groupId"] == null) {
      info("Creating group", data: {
        "users": [
          user.uid,
          data["recipient"]["uid"],
        ],
      });

      final DocumentReference<Map<String, dynamic>> group =
          firestore.collection("groups").doc();
      data["groupId"] = group.id;
      await group.set({
        "users": [
          user.uid,
          data["recipient"]["uid"],
        ],
        "createdAt": now,
        "updatedAt": now,
      });
    }

    await firestore
        .collection("groups")
        .doc(data["groupId"])
        .collection("messages")
        .add({
      "message": data["message"],
      "sender": user.uid,
      "createdAt": now,
      "updatedAt": now,
    });

    return {};
  }
}
