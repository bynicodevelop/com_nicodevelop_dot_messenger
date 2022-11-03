import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/validate_account_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  final FirebaseFirestore firebaseFirestore = FakeFirebaseFirestore();

  group("login", () {
    test("Doit permettre l'authentification d'un utilisateur enregistré",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.login({
        "email": "john@domain.tld",
        "password": "password",
      });

      // ASSERT
      expect(firebaseAuth.currentUser, user);
    });

    test("Doit vérifier que tous les paramètres sont fournis", () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth();

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "expect": () => expect(
                () async => await profileRepository.login({}),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "john",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "john@domain",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "john@domain.tld",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "john@domain.tld",
                  "password": "",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.login({
                  "email": "john@domain.tld",
                  "password": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        }
      ];

      // ACT
      // ASSERT
      for (final Map<String, dynamic> dataset in datasets) {
        dataset["expect"]();
      }
    });

    test("Doit retourner une erreur si l'authentification n'est pas permise",
        () async {
      // ARRANGE
      final List<Map<String, dynamic>> exceptions = [
        {
          "AuthExceptions": AuthExceptions(
            signInWithEmailAndPassword: FirebaseAuthException(
              code: "invalid-credential",
            ),
          ),
          "assert": throwsA(
            isA<UpdateProfileException>().having(
              (e) => e.code,
              "code",
              "invalid_credential",
            ),
          )
        },
        {
          "AuthExceptions": AuthExceptions(
            signInWithEmailAndPassword: FirebaseAuthException(
              code: "user-not-found",
            ),
          ),
          "assert": throwsA(
            isA<UpdateProfileException>().having(
              (e) => e.code,
              "code",
              "user_not_found",
            ),
          )
        },
        {
          "AuthExceptions": AuthExceptions(
            signInWithEmailAndPassword: FirebaseAuthException(
              code: "weak-password",
            ),
          ),
          "assert": throwsA(
            isA<UpdateProfileException>().having(
              (e) => e.code,
              "code",
              "weak_password",
            ),
          )
        },
      ];

      for (Map<String, dynamic> exception in exceptions) {
        final FirebaseAuth firebaseAuth = MockFirebaseAuth(
          authExceptions: exception["AuthExceptions"],
        );

        final ProfileRepository profileRepository = ProfileRepository(
          firebaseAuth,
          firebaseFirestore,
        );

        // ACT
        // ASSERT
        expect(
          () async => await profileRepository.login({
            "email": "john@domain.tld",
            "password": "password",
          }),
          exception["assert"],
        );
      }
    });
  });

  group("register", () {
    test("Doit permettre l'inscription d'un utilisateur", () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth();

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.register({
        "email": "john@domain.tld",
        "password": "password",
      });

      // ASSERT
      expect(firebaseAuth.currentUser, isNotNull);
    });

    test("Doit vérifier que tous les champs sont renseignés", () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth();

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "expect": () => expect(
                () async => await profileRepository.register({}),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "john",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "john@domain",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "email_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "john@domain.tld",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "john@domain.tld",
                  "password": "",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.register({
                  "email": "john@domain.tld",
                  "password": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>()
                      .having((e) => e.code, "code", "password_required"),
                ),
              ),
        }
      ];

      // ACT
      // ASSERT
      for (final Map<String, dynamic> dataset in datasets) {
        dataset["expect"]();
      }
    });

    test("Doit retourner une erreur si l'authentification n'est pas permise",
        () async {
      // ARRANGE
      final List<Map<String, dynamic>> exceptions = [
        {
          "AuthExceptions": AuthExceptions(
            createUserWithEmailAndPassword: FirebaseAuthException(
              code: "email-already-in-use",
            ),
          ),
          "assert": throwsA(
            isA<UpdateProfileException>().having(
              (e) => e.code,
              "code",
              "email_already_in_use",
            ),
          )
        },
      ];

      for (Map<String, dynamic> exception in exceptions) {
        final FirebaseAuth firebaseAuth = MockFirebaseAuth(
          authExceptions: exception["AuthExceptions"],
        );

        final ProfileRepository profileRepository = ProfileRepository(
          firebaseAuth,
          firebaseFirestore,
        );

        // ACT
        // ASSERT
        expect(
          () async => await profileRepository.register({
            "email": "john@domain.tld",
            "password": "password",
          }),
          exception["assert"],
        );
      }
    });
  });

  group("logout", () {
    test("Doit permettre la déconnexion d'un utilisateur", () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.logout();

      // ASSERT
      expect(firebaseAuth.currentUser, isNull);
    });
  });

  group("update", () {
    test("Doit sauvegarder le profil", () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.update({
        "displayName": "Bob",
        "email": "john@domain.tld",
      });

      // ASSERT
      expect(user.displayName, "Bob");
      expect(user.email, "john@domain.tld");
    });

    test(
        "Doit retourner une erreur si la méthode est appellée sans profile connecté",
        () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: false,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await profileRepository.update({
          "displayName": "Bob",
          "email": "john@domain.tld",
        }),
        throwsA(
          isA<AuthenticationException>()
              .having((e) => e.code, "code", "unauthenticated_user"),
        ),
      );
    });

    test("Doit retourner une erreur si le paramètres non sont pas complets",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "bob@somedomain.com",
        displayName: "Bob",
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "uid": "someuid",
                  "displayName": "Bob",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "email_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "uid": "someuid",
                  "displayName": "Bob",
                  "email": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "email_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "uid": "someuid",
                  "displayName": "Bob",
                  "email": "john@domain",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "email_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "uid": "someuid",
                  "displayName": "Bob",
                  "email": "john",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "email_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "uid": "someuid",
                  "displayName": "Bob",
                  "email": "",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "email_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "email": "john@domain.tld",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "display_name_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "email": "john@domain.tld",
                  "displayName": "",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "display_name_required",
                  ),
                ),
              ),
        },
        {
          "expect": () => expect(
                () async => await profileRepository.update({
                  "email": "john@domain.tld",
                  "displayName": " ",
                }),
                throwsA(
                  isA<UpdateProfileException>().having(
                    (e) => e.code,
                    "code",
                    "display_name_required",
                  ),
                ),
              ),
        },
      ];

      // ACT
      // ASSERT
      for (final Map<String, dynamic> dataset in datasets) {
        await dataset["expect"]();
      }
    });
  });

  group("validateEmail", () {
    test("Doit confirmer la validation du compte", () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
        isEmailVerified: false,
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      await firebaseFirestore.collection("check_codes").doc(user.uid).set({
        "code": 1337,
      });

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.validateEmail({
        "code": "1337",
      });

      // ASSERT
      DocumentSnapshot<Map<String, dynamic>> checkCodesSnapshot =
          await firebaseFirestore.collection("check_codes").doc(user.uid).get();

      expect(checkCodesSnapshot.data()!["validated"], isTrue);
    });

    test("Doit retourner une erreur quand le code n'est pas renseigné",
        () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      final List<Map<String, dynamic>> datasets = [
        {
          "code": "",
        },
        {
          "code": " ",
        },
        {
          "code": null,
        },
        {},
      ];

      // ACT
      // ASSERT
      for (final Map<String, dynamic> dataset in datasets) {
        expect(
          () async => await profileRepository.validateEmail(dataset),
          throwsA(
            isA<ValidateAccountException>().having(
              (e) => e.code,
              "code",
              "code_required",
            ),
          ),
        );
      }
    });

    test("Doit retourner une erreur quand le code est invalid", () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
        isEmailVerified: false,
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      await firebaseFirestore.collection("check_codes").doc(user.uid).set({
        "code": 1337,
      });

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await profileRepository.validateEmail({
          "code": "1111",
        }),
        throwsA(
          isA<ValidateAccountException>().having(
            (e) => e.code,
            "code",
            "invalid_code",
          ),
        ),
      );
    });

    test(
        "Doit retourner une erreur quand la méthode est utilisée sans authentification",
        () async {
      // ARRANGE
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: false,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await profileRepository.validateEmail({
          "code": "1111",
        }),
        throwsA(
          isA<AuthenticationException>().having(
            (e) => e.code,
            "code",
            "unauthenticated_user",
          ),
        ),
      );
    });
  });

  group("resendConfirmMail", () {
    test("Doit envoyer un mail de confirmation avec succes", () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
        isEmailVerified: false,
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.resendConfirmMail();

      // ASSERT
      final QuerySnapshot<Map<String, dynamic>> transactionalMails =
          await firebaseFirestore.collection("transactional_mails").get();

      expect(transactionalMails.docs.length, 1);
      expect(transactionalMails.docs.first.data()["userId"], "someuid");
      expect(transactionalMails.docs.first.data()["type"], "confirm_mail");
    });

    test("Doit retourner une erreur si l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: false,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await profileRepository.resendConfirmMail(),
        throwsA(
          isA<AuthenticationException>().having(
            (e) => e.code,
            "code",
            "unauthenticated_user",
          ),
        ),
      );
    });
  });

  group("deleteAccount", () {
    test("Doit supprimer le compte avec succes", () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      await profileRepository.deleteAccount();

      // ASSERT
      expect(firebaseAuth.currentUser, isNull);
    });

    test("Doit retourner une exception quand l'utilisateur n'est pas connecté",
        () async {
      // ARRANGE
      final MockUser user = MockUser(
        uid: "someuid",
        email: "john@domain.tld",
        displayName: "john",
      );

      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: false,
        mockUser: user,
      );

      final ProfileRepository profileRepository = ProfileRepository(
        firebaseAuth,
        firebaseFirestore,
      );

      // ACT
      // ASSERT
      expect(
        () async => await profileRepository.deleteAccount(),
        throwsA(
          isA<AuthenticationException>().having(
            (e) => e.code,
            "code",
            "unauthenticated_user",
          ),
        ),
      );
    });
  });
}
