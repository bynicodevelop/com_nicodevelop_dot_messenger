import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/validate_account_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:validators/sanitizers.dart";
import "package:validators/validators.dart";

class ProfileRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  const ProfileRepository(
    this.firebaseAuth,
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

  void _isAuthenticatedUser() {
    final User? user = firebaseAuth.currentUser;

    if (user == null) {
      throw const AuthenticationException(
        "User is not authenticated",
        "unauthenticated_user",
      );
    }
  }

  Future<User?> get user async {
    await firebaseAuth.currentUser?.reload();

    return firebaseAuth.currentUser;
  }

  Future<void> validateEmail(Map<String, dynamic> data) async {
    final User? user = firebaseAuth.currentUser;

    _isAuthenticatedUser();

    if (data["code"] == null || trim(data["code"]).isEmpty) {
      warn("Code is required", data: data);

      throw const ValidateAccountException(
        "Code required",
        "code_required",
      );
    }

    DocumentSnapshot<Map<String, dynamic>> checkCodeSnapshot =
        await firestore.collection("check_codes").doc(user!.uid).get();

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
      await firebaseAuth.signInWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      info("Login success");
    } on FirebaseAuthException catch (e) {
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

    await firebaseAuth.signOut();
  }

  Future<void> register(Map<String, dynamic> data) async {
    _isVadidEmail(data["email"]);

    _isRequiredField(data["password"], "password");

    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: data["email"],
        password: data["password"],
      );

      info("Register success");
    } on FirebaseAuthException catch (e) {
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
    final User? user = firebaseAuth.currentUser;

    _isAuthenticatedUser();

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
    final User? user = firebaseAuth.currentUser;

    _isAuthenticatedUser();

    await firestore.collection("transactional_mails").add({
      "userId": user!.uid,
      "type": "confirm_mail",
    });

    info("Resend confirm mail", data: {
      "uid": user.uid,
    });
  }

  Future<void> deleteAccount() async {
    final User? user = firebaseAuth.currentUser;

    _isAuthenticatedUser();

    await user!.delete();

    info("Account deleted", data: {
      "uid": user.uid,
    });

    await logout();
  }
}
