import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/search_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:validators/sanitizers.dart";

class SearchRepository {
  final FirebaseFirestore firestore;

  const SearchRepository(
    this.firestore,
  );

  Future<List<Map<String, dynamic>>> search(Map<String, dynamic> data) async {
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

    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return {
        "uid": doc.id,
        "displayName": doc.data()["displayName"],
      };
    }).toList();
  }
}
