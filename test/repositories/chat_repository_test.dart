import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/chat_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("load", () {});

  group("post", () {
    late FakeFirebaseFirestore firestore;
    late FirebaseAuth auth;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        signedIn: true,
      );
    });

    test("Doit permettre de poster un message avec succès dans un groupe",
        () async {
      // ARRANGE
      await firestore.collection("groups").doc("1").set({
        "uid": "1",
      });

      final ChatRepository chatRepository = ChatRepository(
        firestore,
        auth,
      );

      // ACT
      await chatRepository.post({
        "groupId": "1",
        "message": "Hello world",
        "recipient": {"uid": "1"},
      });

      // ASSERT
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection("groups")
          .doc("1")
          .collection("messages")
          .get();

      expect(snapshot.docs.length, 1);
    });

    test("Doit permettre de poster un message avec succès en créant un groupe",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "2",
      );

      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final ChatRepository chatRepository = ChatRepository(
        firestore,
        auth,
      );

      // ACT
      await chatRepository.post({
        "recipient": {"uid": "1"},
        "message": "Hello world",
      });

      // ASSERT
      final QuerySnapshot<Map<String, dynamic>> snapshotGroup =
          await firestore.collection("groups").get();

      final QuerySnapshot<Map<String, dynamic>> snapshotMessage =
          await snapshotGroup.docs.first.reference.collection("messages").get();

      expect(snapshotGroup.docs.length, 1);
      expect(snapshotMessage.docs.length, 1);

      expect(snapshotGroup.docs.first.data()["users"].contains("1"), isTrue);
      expect(snapshotGroup.docs.first.data()["users"].contains("2"), isTrue);

      expect(snapshotMessage.docs.first.data()["sender"], "2");
      expect(snapshotMessage.docs.first.data()["message"], "Hello world");
    });

    test("Doit retourner une erreur si le message est vide", () async {
      // ARRANGE
      final ChatRepository chatRepository = ChatRepository(
        firestore,
        auth,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "recipient": {"uid": "1"},
        },
        {
          "recipient": {"uid": "1"},
          "message": "",
        },
        {
          "recipient": {"uid": "1"},
          "message": " ",
        },
        {
          "recipient": {"uid": "1"},
          "message": "  ",
        },
      ];

      // ACT
      // ASSERT
      for (final dataset in datasets) {
        expect(
          () async => await chatRepository.post(dataset),
          throwsA(
            isA<ChatException>().having(
              (p0) => p0.code,
              "code",
              "message_required",
            ),
          ),
        );
      }
    });

    test(
        "Doit retourner une erreur si le certains champs requis ne sont pas enregistrés",
        () async {
      // ARRANGE
      final ChatRepository chatRepository = ChatRepository(
        firestore,
        auth,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "recipient": {"uid": ""},
          "message": "Hello World",
        },
        {
          "recipient": {},
          "message": "Hello World",
        },
        {
          "message": "Hello World",
        },
      ];

      // ACT
      // ASSERT
      for (final dataset in datasets) {
        expect(
          () async => await chatRepository.post(dataset),
          throwsA(
            isA<ChatException>().having(
              (p0) => p0.code,
              "code",
              "recipient_required",
            ),
          ),
        );
      }
    });

    test("Doit retourner une erreur si l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE
      final ChatRepository chatRepository = ChatRepository(
        firestore,
        MockFirebaseAuth(
          signedIn: false,
        ),
      );

      // ACT
      // ASSERT
      expect(
        () async => await chatRepository.post({}),
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
