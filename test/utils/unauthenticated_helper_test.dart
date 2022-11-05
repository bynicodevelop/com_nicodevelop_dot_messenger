import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/utils/unauthenticated_helper.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("Doit générer une exception si l'utilisateur n'est pas authentifier",
      () {
    // ARRANGE
    final FirebaseAuth auth = MockFirebaseAuth(signedIn: false);

    // ACT
    // ASSERT
    expect(
      () => isUnauthenticated(auth),
      throwsA(
        isA<AuthenticationException>()
            .having(
              (p0) => p0.code,
              "code",
              "unauthenticated",
            )
            .having(
              (p0) => p0.message,
              "message",
              "User is not authenticated",
            ),
      ),
    );
  });

  test("Doit ne pas générer d'exception si l'utilisateur est authentifier", () {
    // ARRANGE
    final FirebaseAuth auth = MockFirebaseAuth(
      signedIn: true,
    );

    // ACT
    // ASSERT
    expect(
      () => isUnauthenticated(auth),
      returnsNormally,
    );
  });
}
