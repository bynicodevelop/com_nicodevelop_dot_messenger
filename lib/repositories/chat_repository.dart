import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/chat_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:com_nicodevelop_dotmessenger/utils/unauthenticated_helper.dart";
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
    info(
      "ChatRepository.load",
      data: data,
    );

    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    if (!data.containsKey("groupId")) {
      throw const ChatException(
        "groupId is required",
        "group_id_required",
      );
    }

    final String groupId = data["groupId"];

    DocumentSnapshot<Map<String, dynamic>> groupDocumentSnapshot =
        await firestore.collection("groups").doc(groupId).get();

    if (!groupDocumentSnapshot.exists) {
      throw const ChatException(
        "Group not found",
        "group_not_found",
      );
    }

    final Map<String, dynamic> group = groupDocumentSnapshot.data()!;

    if (!group["users"].contains(user!.uid)) {
      throw const ChatException(
        "Group users not found",
        "group_users_not_found",
      );
    }

    groupDocumentSnapshot.reference
        .collection("messages")
        .orderBy(
          "createdAt",
          descending: true,
        )
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      final List<Map<String, dynamic>> messages = [];

      for (var documentSnapshot in querySnapshot.docs) {
        final Map<String, dynamic> message = documentSnapshot.data();

        messages.add({
          ...message,
          "uid": documentSnapshot.id,
          "isMe": message["sender"] == user.uid,
        });
      }

      _messagesController.add(messages);
    });
  }

  Future<Map<String, dynamic>> post(Map<String, dynamic> data) async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

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

    if (!data.containsKey("groupId") || data["groupId"] == null) {
      info("Creating group", data: {
        "users": [
          user!.uid,
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
      });
    }

    DocumentReference<Map<String, dynamic>> message = await firestore
        .collection("groups")
        .doc(data["groupId"])
        .collection("messages")
        .add({
      "message": data["message"],
      "sender": user!.uid,
    });

    return {
      "uid": message.id,
      "groupId": data["groupId"],
      "message": data["message"],
      "sender": user.uid,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "isMe": true,
    };
  }
}
