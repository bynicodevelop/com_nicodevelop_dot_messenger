import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/search_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:validators/sanitizers.dart";

class SearchRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  const SearchRepository(
    this.firestore,
    this.auth,
  );

  Future<List<Map<String, dynamic>>> search(Map<String, dynamic> data) async {
    final User? user = auth.currentUser;

    if (user == null) {
      throw const AuthenticationException(
        "User not connected",
        "unauthenticated",
      );
    }

    if (!data.containsKey("query")) {
      warn("data does not contain key 'query'");

      throw const SearchException(
        "Query is missing",
        "query_required",
      );
    }

    final String query = trim(data["query"]);

    if (query.length < 3) {
      return [];
    }

    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("users")
        .orderBy("displayName")
        .startAt([query]).endAt(["$query\uf8ff"]).get();

    return (await Future.wait(snapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
      final QuerySnapshot<Map<String, dynamic>> groupSnapshot = await firestore
          .collection("groups")
          .where("users", arrayContainsAny: [user.uid, doc.id]).get();

      final Map<String, dynamic> profile = {
        "uid": doc.id,
        "displayName": doc.data()["displayName"],
      };

      if (groupSnapshot.docs.isNotEmpty) {
        profile["groupId"] = groupSnapshot.docs.first.id;
      }

      return profile;
    })))
        .where((profile) => profile["uid"] != user.uid)
        .toList();
  }
}
