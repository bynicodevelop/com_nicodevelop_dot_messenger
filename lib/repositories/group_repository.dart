import "dart:async";

import "package:clock/clock.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:firebase_auth/firebase_auth.dart";

class GroupRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  GroupRepository(
    this.auth,
    this.firestore,
  );

  final StreamController<List<Map<String, dynamic>>> _groupsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get groups => _groupsController.stream;

  Future<void> load() async {
    final User? user = auth.currentUser;

    if (user == null) {
      throw const AuthenticationException(
        "User is not authenticated",
        "unauthenticated",
      );
    }

    final Stream<QuerySnapshot<Map<String, dynamic>>> groupsQuerySnapshot =
        firestore
            .collection("groups")
            .where("users", arrayContains: user.uid)
            .snapshots();

    groupsQuerySnapshot
        .listen((QuerySnapshot<Map<String, dynamic>> event) async {
      final List<Map<String, dynamic>> groups = [];

      for (final QueryDocumentSnapshot<Map<String, dynamic>> document
          in event.docs) {
        final Map<String, dynamic> group = document.data();

        if (group["lastMessage"] == null || group["lastMessage"].isEmpty) {
          continue;
        }

        group["lastMessageTime"] = ((group["lastMessageTime"] ??
                Timestamp.fromDate(clock.now())) as Timestamp)
            .toDate();

        final List<String> recipients = List<String>.from(group["users"])
            .where((id) => id != user.uid)
            .toList();

        List<Map<String, dynamic>> users = [];

        users.add({
          "uid": user.uid,
          "displayName": user.displayName,
          "photoUrl": user.photoURL ?? "",
          "currentUser": true,
        });

        for (final String recipient in recipients) {
          DocumentSnapshot<Map<String, dynamic>> user =
              await firestore.collection("users").doc(recipient).get();

          final Map<String, dynamic> data = user.data()!;

          data["photoUrl"] = data["photoUrl"] ?? "";

          users.add({
            ...data,
            "uid": user.id,
          });
        }

        groups.add({
          ...group,
          "users": users,
          "uid": document.id,
        });
      }

      _groupsController.add(groups);
    });
  }
}
