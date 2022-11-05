import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:firebase_auth/firebase_auth.dart";

void isUnauthenticated(FirebaseAuth auth) {
  if (auth.currentUser == null) {
    throw const AuthenticationException(
      "User is not authenticated",
      "unauthenticated",
    );
  }
}
