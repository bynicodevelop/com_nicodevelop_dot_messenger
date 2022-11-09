import "package:clock/clock.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("load", () {
    late FirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    test(
        "Doit retourner une liste des groupes (1 groupe) où l'utilisateur est présent",
        () async {
      // ARRANGE
      final List<Map<String, dynamic>> users = [
        {
          "uid": "1",
          "displayName": "user 1",
          "photoUrl": "https://example.com/user1.png",
        },
        {
          "uid": "2",
          "displayName": "user 2",
          "photoUrl": "https://example.com/user2.png",
        },
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["uid"]).set({
          "displayName": user["displayName"],
          "photoUrl": user["photoUrl"],
        });
      }

      final Timestamp lastMessageTime = Timestamp.now();

      final List<Map<String, dynamic>> datasets = [
        {
          "id": "group1",
          "users": ["1", "2"],
          "lastMessage": "Hello",
          "lastMessageTime": lastMessageTime,
        },
        {
          "id": "group2",
          "users": ["2", "3"],
          "lastMessage": "Coucou",
          "lastMessageTime": lastMessageTime,
        }
      ];

      for (final Map<String, dynamic> dataset in datasets) {
        await firestore.collection("groups").doc(dataset["id"]).set({
          "users": dataset["users"],
          "lastMessage": dataset["lastMessage"],
          "lastMessageTime": dataset["lastMessageTime"],
        });
      }

      final MockUser user = MockUser(
        displayName: "user 1",
        photoURL: "https://example.com/user1.png",
        uid: "1",
      );

      final MockFirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final GroupRepository groupRepository = GroupRepository(
        auth,
        firestore,
      );

      // ACT
      await groupRepository.load();

      // ASSERT
      expect(
        groupRepository.groups,
        emitsInOrder(
          [
            [
              {
                "uid": "group1",
                "users": [
                  {
                    "uid": "1",
                    "displayName": "user 1",
                    "photoUrl": "https://example.com/user1.png",
                    "currentUser": true,
                  },
                  {
                    "uid": "2",
                    "displayName": "user 2",
                    "photoUrl": "https://example.com/user2.png",
                  },
                ],
                "lastMessage": "Hello",
                "lastMessageTime": lastMessageTime.toDate(),
              },
            ],
          ],
        ),
      );
    });

    test(
        "Doit retourner une liste des groupes (1 groupe) où l'utilisateur est présent sans photoUrl",
        () async {
      // ARRANGE
      final List<Map<String, dynamic>> users = [
        {
          "uid": "1",
          "displayName": "user 1",
        },
        {
          "uid": "2",
          "displayName": "user 2",
          "photoUrl": "",
        },
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["uid"]).set({
          "displayName": user["displayName"],
          "photoUrl": user["photoUrl"],
        });
      }

      final Timestamp lastMessageTime = Timestamp.now();

      final List<Map<String, dynamic>> datasets = [
        {
          "id": "group1",
          "users": ["1", "2"],
          "lastMessage": "Hello",
          "lastMessageTime": lastMessageTime,
        },
        {
          "id": "group2",
          "users": ["2", "3"],
          "lastMessage": "Coucou",
          "lastMessageTime": lastMessageTime,
        }
      ];

      for (final Map<String, dynamic> dataset in datasets) {
        await firestore.collection("groups").doc(dataset["id"]).set({
          "users": dataset["users"],
          "lastMessage": dataset["lastMessage"],
          "lastMessageTime": dataset["lastMessageTime"],
        });
      }

      final MockUser user = MockUser(
        displayName: "user 1",
        photoURL: "",
        uid: "1",
      );

      final MockFirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final GroupRepository groupRepository = GroupRepository(
        auth,
        firestore,
      );

      // ACT
      await groupRepository.load();

      // ASSERT
      expect(
        groupRepository.groups,
        emitsInOrder(
          [
            [
              {
                "uid": "group1",
                "users": [
                  {
                    "uid": "1",
                    "displayName": "user 1",
                    "photoUrl": "",
                    "currentUser": true,
                  },
                  {
                    "uid": "2",
                    "displayName": "user 2",
                    "photoUrl": "",
                  },
                ],
                "lastMessage": "Hello",
                "lastMessageTime": lastMessageTime.toDate(),
              },
            ],
          ],
        ),
      );
    });

    test("Doit ne rien retourner si le message est vide", () async {
      // ARRANGE
      final List<Map<String, dynamic>> users = [
        {
          "uid": "1",
          "displayName": "user 1",
        },
        {
          "uid": "2",
          "displayName": "user 2",
          "photoUrl": "",
        },
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["uid"]).set({
          "displayName": user["displayName"],
          "photoUrl": user["photoUrl"],
        });
      }

      final Timestamp lastMessageTime = Timestamp.now();

      final List<Map<String, dynamic>> datasets = [
        {
          "id": "group1",
          "users": ["1", "2"],
          "lastMessageTime": lastMessageTime,
        },
      ];

      for (final Map<String, dynamic> dataset in datasets) {
        await firestore.collection("groups").doc(dataset["id"]).set({
          "users": dataset["users"],
          "lastMessage": dataset["lastMessage"],
          "lastMessageTime": dataset["lastMessageTime"],
        });
      }

      final MockUser user = MockUser(
        displayName: "user 1",
        photoURL: "",
        uid: "1",
      );

      final MockFirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final GroupRepository groupRepository = GroupRepository(
        auth,
        firestore,
      );

      // ACT
      await groupRepository.load();

      // ASSERT
      expect(
        groupRepository.groups,
        emitsInOrder(
          [
            [],
          ],
        ),
      );
    });

    test(
        "Doit retourner une liste des groupes (1 groupe) sans timestamp du dernier message",
        () async {
      // ARRANGE
      final List<Map<String, dynamic>> users = [
        {
          "uid": "1",
          "displayName": "user 1",
        },
        {
          "uid": "2",
          "displayName": "user 2",
          "photoUrl": "",
        },
      ];

      for (final Map<String, dynamic> user in users) {
        await firestore.collection("users").doc(user["uid"]).set({
          "displayName": user["displayName"],
          "photoUrl": user["photoUrl"],
        });
      }
      withClock(
        Clock.fixed(DateTime.now()),
        () async {
          final Timestamp lastMessageTime = Timestamp.fromDate(clock.now());

          final List<Map<String, dynamic>> datasets = [
            {
              "id": "group1",
              "users": ["1", "2"],
              "lastMessage": "Hello",
            },
          ];

          for (final Map<String, dynamic> dataset in datasets) {
            await firestore.collection("groups").doc(dataset["id"]).set({
              "users": dataset["users"],
              "lastMessage": dataset["lastMessage"],
              "lastMessageTime": dataset["lastMessageTime"],
            });
          }

          final MockUser user = MockUser(
            displayName: "user 1",
            photoURL: "",
            uid: "1",
          );

          final MockFirebaseAuth auth = MockFirebaseAuth(
            signedIn: true,
            mockUser: user,
          );

          final GroupRepository groupRepository = GroupRepository(
            auth,
            firestore,
          );

          // ACT
          await groupRepository.load();

          // ASSERT
          expect(
            groupRepository.groups,
            emitsInOrder(
              [
                [
                  {
                    "uid": "group1",
                    "users": [
                      {
                        "uid": "1",
                        "displayName": "user 1",
                        "photoUrl": "",
                        "currentUser": true,
                      },
                      {
                        "uid": "2",
                        "displayName": "user 2",
                        "photoUrl": "",
                      },
                    ],
                    "lastMessage": "Hello",
                    "lastMessageTime": lastMessageTime.toDate(),
                  },
                ],
              ],
            ),
          );
        },
      );
    });

    test("Doit retourner une erreur si l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE
      final FirebaseAuth auth = MockFirebaseAuth(
        signedIn: false,
      );

      final GroupRepository groupRepository = GroupRepository(
        auth,
        firestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await groupRepository.load(),
        throwsA(
          isA<AuthenticationException>().having(
            (p0) => p0.code,
            "code",
            "unauthenticated",
          ),
        ),
      );
    });
  });
}
