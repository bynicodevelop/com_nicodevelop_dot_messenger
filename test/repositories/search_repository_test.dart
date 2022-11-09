import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/search_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/search_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("search", () {
    final FirebaseFirestore firestore = FakeFirebaseFirestore();
    late FirebaseAuth auth;

    setUp(() async {
      auth = MockFirebaseAuth(
        signedIn: true,
      );

      final List<Map<String, dynamic>> users = [
        {
          "uid": "1",
          "displayName": "test",
        },
        {
          "uid": "2",
          "displayName": "test2",
        },
        {
          "uid": "3",
          "displayName": "john",
        },
        {
          "uid": "4",
          "displayName": "jeff",
        },
        {
          "uid": "5",
          "displayName": "dolly",
        },
        {
          "uid": "6",
          "displayName": "pit",
        },
        {
          "uid": "7",
          "displayName": "pat",
        }
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["uid"]).set(user);
      }

      final List<Map<String, dynamic>> groups = [
        {
          "uid": "group1",
          "users": ["4", "5"],
        },
        {
          "uid": "group2",
          "users": ["4", "6"],
        },
        {
          "uid": "group3",
          "users": ["5", "7"],
        },
      ];

      for (final Map<String, dynamic> group in groups) {
        await firestore.collection("groups").doc(group["uid"]).set({
          "users": group["users"],
        });
      }
    });

    test("Doit retourner une liste vide", () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

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

      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

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
      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "john",
      });

      // ASSERT
      expect(result, [
        {
          "uid": "3",
          "displayName": "john",
        },
      ]);
    });

    test("Doit retourner une liste vide avec 2 résultats", () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "test",
      });

      // ASSERT
      expect(result, [
        {
          "uid": "1",
          "displayName": "test",
        },
        {
          "uid": "2",
          "displayName": "test2",
        },
      ]);
    });

    test("Doit retourner une erreur si l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE
      auth = MockFirebaseAuth(
        signedIn: false,
      );

      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

      // ACT
      // ASSERT
      expect(
          () async => await searchRepository.search({"query": ""}),
          throwsA(
            isA<AuthenticationException>().having(
              (p0) => p0.code,
              "code",
              "unauthenticated",
            ),
          ));
    });

    test(
        "Doit retourner une liste vide avec 1 résultat qui contient un groupe en commun",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "4",
      );

      final FirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "dolly",
      });

      // ASSERT
      expect(result, [
        {
          "uid": "5",
          "displayName": "dolly",
          "groupId": "group1",
        },
      ]);
    });

    test("Doit exclure l'utilisateur courant de la liste des résultats",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "4",
      );

      final FirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

      // ACT
      final List<Map<String, dynamic>> result = await searchRepository.search({
        "query": "jeff",
      });

      // ASSERT
      expect(result, []);
    });

    test("Doit retourner une erreur si la donnéee query n'est pas renseignée",
        () async {
      // ARRANGE
      final SearchRepository searchRepository = SearchRepository(
        firestore,
        auth,
      );

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
