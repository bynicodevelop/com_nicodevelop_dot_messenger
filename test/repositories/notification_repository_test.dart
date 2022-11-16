import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/notification_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/notification_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<FirebaseMessaging>()])
import "notification_repository_test.mocks.dart";

void main() {
  late FirebaseAuth mockFirebaseAuth;
  late FirebaseFirestore mockFirebaseFirestore;
  late FirebaseMessaging mockFirebaseMessaging;

  setUp(() {
    mockFirebaseMessaging = MockFirebaseMessaging();
    mockFirebaseFirestore = FakeFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth(
      signedIn: true,
    );
  });

  group("initialize", () {
    test("returns AuthorizationStatusEnum.authorized", () async {
      // ARRANGE
      when(mockFirebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )).thenAnswer((_) async => const NotificationSettings(
            authorizationStatus: AuthorizationStatus.authorized,
            alert: AppleNotificationSetting.enabled,
            announcement: AppleNotificationSetting.disabled,
            badge: AppleNotificationSetting.enabled,
            carPlay: AppleNotificationSetting.disabled,
            criticalAlert: AppleNotificationSetting.disabled,
            sound: AppleNotificationSetting.enabled,
            lockScreen: AppleNotificationSetting.enabled,
            notificationCenter: AppleNotificationSetting.enabled,
            showPreviews: AppleShowPreviewSetting.always,
            timeSensitive: AppleNotificationSetting.disabled,
          ));

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      AuthorizationStatusEnum authorizationStatusEnum =
          await notificationRepository.initialize();

      // ASSERT
      expect(
        authorizationStatusEnum,
        AuthorizationStatusEnum.authorized,
      );
    });

    test("returns AuthorizationStatusEnum.provisional", () async {
      // ARRANGE
      when(mockFirebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )).thenAnswer((_) async => const NotificationSettings(
            authorizationStatus: AuthorizationStatus.provisional,
            alert: AppleNotificationSetting.enabled,
            announcement: AppleNotificationSetting.disabled,
            badge: AppleNotificationSetting.enabled,
            carPlay: AppleNotificationSetting.disabled,
            criticalAlert: AppleNotificationSetting.disabled,
            sound: AppleNotificationSetting.enabled,
            lockScreen: AppleNotificationSetting.enabled,
            notificationCenter: AppleNotificationSetting.enabled,
            showPreviews: AppleShowPreviewSetting.always,
            timeSensitive: AppleNotificationSetting.disabled,
          ));

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      AuthorizationStatusEnum authorizationStatusEnum =
          await notificationRepository.initialize();

      // ASSERT
      expect(
        authorizationStatusEnum,
        AuthorizationStatusEnum.provisional,
      );
    });

    test("returns AuthorizationStatusEnum.denied", () async {
      // ARRANGE
      when(mockFirebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )).thenAnswer((_) async => const NotificationSettings(
            authorizationStatus: AuthorizationStatus.denied,
            alert: AppleNotificationSetting.enabled,
            announcement: AppleNotificationSetting.disabled,
            badge: AppleNotificationSetting.enabled,
            carPlay: AppleNotificationSetting.disabled,
            criticalAlert: AppleNotificationSetting.disabled,
            sound: AppleNotificationSetting.enabled,
            lockScreen: AppleNotificationSetting.enabled,
            notificationCenter: AppleNotificationSetting.enabled,
            showPreviews: AppleShowPreviewSetting.always,
            timeSensitive: AppleNotificationSetting.disabled,
          ));

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      AuthorizationStatusEnum authorizationStatusEnum =
          await notificationRepository.initialize();

      // ASSERT
      expect(
        authorizationStatusEnum,
        AuthorizationStatusEnum.denied,
      );
    });
  });

  group("saveToken", () {
    test("Doit enregistrer le token en base de données", () async {
      // ARRANGE
      await mockFirebaseFirestore
          .collection("users")
          .doc(mockFirebaseAuth.currentUser!.uid)
          .set({
        "email": "john@domain.tld",
      });

      when(mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => "123456789");

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      await notificationRepository.saveToken();

      // ASSERT
      verify(mockFirebaseMessaging.getToken());

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await mockFirebaseFirestore
              .collection("users")
              .doc(mockFirebaseAuth.currentUser!.uid)
              .get();

      expect(documentSnapshot.data()!["token"], "123456789");
    });

    test("Doit retourner une erreur si le document user n'existe pas",
        () async {
      // ARRANGE
      when(mockFirebaseMessaging.getToken())
          .thenAnswer((_) async => "123456789");

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      // ASSERT
      expect(
        () async => await notificationRepository.saveToken(),
        throwsA(isA<NotificationException>().having(
          (e) => e.code,
          "code",
          "token_not_saved",
        )),
      );
    });

    test("Doit retourner une erreur si l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE
      mockFirebaseAuth = MockFirebaseAuth(
        signedIn: false,
      );

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      // ASSERT
      expect(
        () async => await notificationRepository.saveToken(),
        throwsA(isA<AuthenticationException>().having(
          (e) => e.code,
          "code",
          "unauthenticated",
        )),
      );
    });

    test("Doit retourner une erreur si le token en empty", () async {
      // ARRANGE
      when(mockFirebaseMessaging.getToken()).thenAnswer((_) async => null);

      NotificationRepository notificationRepository = NotificationRepository(
        mockFirebaseAuth,
        mockFirebaseFirestore,
        mockFirebaseMessaging,
      );

      // ACT
      // ASSERT
      expect(
        () async => await notificationRepository.saveToken(),
        throwsA(isA<NotificationException>().having(
          (e) => e.code,
          "code",
          "invalid_token",
        )),
      );
    });
  });
}
