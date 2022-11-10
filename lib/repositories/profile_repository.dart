import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/validate_account_exception.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:com_nicodevelop_dotmessenger/utils/unauthenticated_helper.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:validators/sanitizers.dart";
import "package:validators/validators.dart";

class ProfileRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const ProfileRepository(
    this.auth,
    this.firestore,
  );

  void _isVadidEmail(String? email) {
    if (email == null || !isEmail(trim(email))) {
      throw const UpdateProfileException(
        "Email required",
        "email_required",
      );
    }
  }

  void _isRequiredField(String? field, String fieldName) {
    if (field == null || trim(field).isEmpty) {
      throw UpdateProfileException(
        "$fieldName required",
        "${fieldName}_required",
      );
    }
  }

  Stream<UserModel?> get userModel {
    User? user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap({
          "emailVerified": user.emailVerified,
          "email": user.email,
          "displayName": user.displayName,
          ...snapshot.data() ?? {},
          "uid": user.uid,
        });
      }

      return null;
    });
  }

  Future<UserModel?> get user async {
    await auth.currentUser?.reload();

    return UserModel.fromMap({
      "uid": auth.currentUser?.uid ?? "",
      "displayName": auth.currentUser?.displayName ?? "",
      "email": auth.currentUser?.email ?? "",
      "emailVerified": auth.currentUser?.emailVerified ?? false,
    });
  }

  Future<void> validateEmail(Map<String, dynamic> data) async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    if (data["code"] == null || trim(data["code"]).isEmpty) {
      warn("Code is required", data: data);

      throw const ValidateAccountException(
        "Code required",
        "code_required",
      );
    }

    DocumentSnapshot<Map<String, dynamic>> checkCodeSnapshot =
        await firestore.collection("check_codes").doc(user!.uid).get();

    if (!checkCodeSnapshot.exists) {
      warn(
        "Code not found",
        data: data,
      );

      throw const ValidateAccountException(
        "Invalid code",
        "invalid_code",
      );
    }

    final Map<String, dynamic> checkCodeData = checkCodeSnapshot.data()!;

    if (checkCodeData["code"].toString() != data["code"].toString()) {
      warn("Validation account failed", data: {
        "code": data["code"],
      });

      throw const ValidateAccountException(
        "Invalid code",
        "invalid_code",
      );
    }

    await checkCodeSnapshot.reference.update({
      "validated": true,
    });
  }

  Future<void> login(Map<String, dynamic> data) async {
    _isVadidEmail(data["email"]);

    _isRequiredField(data["password"], "password");

    try {
      await auth.signInWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      info("Login success");
    } on FirebaseException catch (e) {
      warn("Login error", data: {
        "code": e.code,
        "message": e.message,
      });

      throw UpdateProfileException(
        e.code.replaceAll("-", " "),
        e.code.replaceAll("-", "_"),
      );
    }
  }

  Future<void> logout() async {
    info("Logout");

    await auth.signOut();
  }

  Future<void> register(Map<String, dynamic> data) async {
    _isVadidEmail(data["email"]);

    _isRequiredField(data["password"], "password");

    try {
      await auth.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      info("Register success");
    } on FirebaseException catch (e) {
      warn("Register error", data: {
        "code": e.code,
        "message": e.message,
      });

      throw UpdateProfileException(
        e.code.replaceAll("-", " "),
        e.code.replaceAll("-", "_"),
      );
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    _isVadidEmail(data["email"]);

    _isRequiredField(data["displayName"], "display_name");

    if (data["displayName"] != user!.displayName) {
      await user.updateDisplayName(
        data["displayName"],
      );

      info("User display name updated", data: {
        "uid": user.uid,
        "displayName": data["displayName"],
      });
    }

    if (data["email"] != user.email) {
      await user.updateDisplayName(
        data["email"],
      );

      info("User email updated", data: {
        "uid": user.uid,
        "email": data["email"],
      });
    }
  }

  Future<void> resendConfirmMail() async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    await firestore.collection("transactional_mails").add({
      "userId": user!.uid,
      "type": "confirm_mail",
    });

    info("Resend confirm mail", data: {
      "uid": user.uid,
    });
  }

  Future<void> deleteAccount() async {
    final User? user = auth.currentUser;

    isUnauthenticated(auth);

    await user!.delete();

    info("Account deleted", data: {
      "uid": user.uid,
    });

    await logout();
  }
}
