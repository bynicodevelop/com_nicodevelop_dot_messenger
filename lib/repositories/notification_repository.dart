import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/notification_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:com_nicodevelop_dotmessenger/utils/unauthenticated_helper.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging/firebase_messaging.dart";

enum AuthorizationStatusEnum {
  authorized,
  provisional,
  denied,
}

class NotificationRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseMessaging messaging;

  const NotificationRepository(
    this.auth,
    this.firebaseFirestore,
    this.messaging,
  );

  Stream<String> get onRefreshToken => messaging.onTokenRefresh;

  Future<AuthorizationStatusEnum> initialize() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return AuthorizationStatusEnum.authorized;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return AuthorizationStatusEnum.provisional;
    }

    return AuthorizationStatusEnum.denied;
  }

  Future<void> saveToken() async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    String? token = await messaging.getToken();

    if (token == null) {
      throw const NotificationException(
        "Invalid token",
        "invalid_token",
      );
    }

    try {
      await firebaseFirestore.collection("users").doc(user!.uid).update({
        "token": token,
      });
    } on FirebaseException catch (e) {
      error("Error saving token", data: {
        "error": e.toString(),
        "message": e.message,
        "code": e.code,
      });

      throw const NotificationException(
        "Error saving token",
        "token_not_saved",
      );
    }
  }
}
