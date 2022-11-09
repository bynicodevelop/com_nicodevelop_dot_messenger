import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/profile/profile_bloc.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "profile_bloc_test.mocks.dart";

void main() {
  final MockUser user = MockUser(
    isAnonymous: false,
    uid: "123456789",
    email: "john@domain.tld",
    isEmailVerified: true,
  );

  blocTest<ProfileBloc, ProfileState>(
    "Doit retourner les informations de profile",
    build: () {
      final ProfileRepository profileRepository = MockProfileRepository();

      when(profileRepository.user).thenAnswer((_) async => UserModel.fromMap({
            "uid": user.uid,
            "displayName": user.displayName,
            "email": user.email,
            "emailVerified": user.emailVerified,
          }));

      return ProfileBloc(
        profileRepository,
      );
    },
    act: (ProfileBloc bloc) => bloc.add(OnProfileEvent()),
    expect: () => [
      ProfileLoadingState(),
      ProfileSuccessState(
        user: UserModel.fromMap({
          "uid": user.uid,
          "displayName": user.displayName,
          "email": user.email,
          "emailVerified": user.emailVerified,
        }),
      ),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    "Doit une erreur d'utilisateur non authentifié",
    build: () {
      final ProfileRepository profileRepository = MockProfileRepository();

      when(profileRepository.user).thenAnswer((_) async => null);

      return ProfileBloc(
        profileRepository,
      );
    },
    act: (ProfileBloc bloc) => bloc.add(OnProfileEvent()),
    expect: () => [
      ProfileLoadingState(),
      const ProfileFailureState(
        code: "user_not_authenticated",
      ),
    ],
  );
}
