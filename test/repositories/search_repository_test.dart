import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/search_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/search_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("search", () {
    final FirebaseFirestore firestore = FakeFirebaseFirestore();

    setUp(() async {
      final List<Map<String, dynamic>> users = [
        {
          "id": "1",
          "displayName": "test",
        },
        {
          "id": "2",
          "displayName": "test2",
        },
        {
          "id": "3",
          "displayName": "john",
        },
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["id"]).set(user);
      }
    });

    test("Doit retourner une liste vide", () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(firestore);

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "test3",
      });

      // ASSERT
      expect(result, []);
    });

    test("Doit retourner une liste vide", () async {
      // ARRANGE
      final List<String> queries = ["    ", " sd", "s ", " ", "te"];

      final SearchRepository searchRepository = SearchRepository(firestore);

      // ACT
      for (final String query in queries) {
        final List<Map<String, dynamic>> result =
            await searchRepository.search({
          "query": query,
        });

        // ASSERT
        expect(result, []);
      }
    });

    test("Doit retourner une liste vide avec 1 résultat", () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(firestore);

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "john",
      });

      // ASSERT
      expect(result, [
        {
          "id": "3",
          "displayName": "john",
        },
      ]);
    });

    test("Doit retourner une liste vide avec 2 résultats", () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(firestore);

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "test",
      });

      // ASSERT
      expect(result, [
        {
          "id": "1",
          "displayName": "test",
        },
        {
          "id": "2",
          "displayName": "test2",
        },
      ]);
    });

    test("Doit retourner une erreur si la donnéee query n'est pas renseignée",
        () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(firestore);

      // ACT
      // ASSERT
      expect(
        () async => await searchRepository.search({}),
        throwsA(isA<SearchException>().having(
          (SearchException e) => e.code,
          "code",
          "query_required",
        )),
      );
    });
  });
}
