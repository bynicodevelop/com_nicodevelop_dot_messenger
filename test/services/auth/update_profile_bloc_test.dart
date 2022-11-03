import "package:bloc_test/bloc_test.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/update_profile/update_profile_bloc.dart";
import "package:fake_cloud_firestore/fake_cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
// ignore: unused_import
import "package:mockito/mockito.dart";

void main() {
  final FirebaseFirestore firestore = FakeFirebaseFirestore();
  late ProfileRepository profileRepository;

  blocTest<UpdateProfileBloc, UpdateProfileState>(
    "Doit permettre la mise à jour d'un profile",
    build: () {
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(
          uid: "someuid",
          email: "john@domain.tld",
        ),
      );

      profileRepository = ProfileRepository(
        firebaseAuth,
        firestore,
      );

      return UpdateProfileBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        const OnUpdateProfileEvent(
          data: {
            "email": "jeff@domain.tld",
            "displayName": "Jeff",
          },
        ),
      );
    },
    expect: () => [
      UpdateProfileLoadingState(),
      UpdateProfileSuccessState(),
    ],
  );

  blocTest<UpdateProfileBloc, UpdateProfileState>(
    "Doit retourner une erreur lors de la mise à jour d'un profile",
    build: () {
      final FirebaseAuth firebaseAuth = MockFirebaseAuth(
        signedIn: false,
        mockUser: MockUser(
          uid: "someuid",
          email: "john@domain.tld",
        ),
      );

      profileRepository = ProfileRepository(
        firebaseAuth,
        firestore,
      );

      return UpdateProfileBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        const OnUpdateProfileEvent(
          data: {
            "email": "jeff@domain.tld",
            "displayName": "Jeff",
          },
        ),
      );
    },
    expect: () => [
      UpdateProfileLoadingState(),
      const UpdateProfileFailureState(
        code: "unauthenticated_user",
      ),
    ],
  );
}
