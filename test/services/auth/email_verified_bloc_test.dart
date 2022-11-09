import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/email_verified/email_verified_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "email_verified_bloc_test.mocks.dart";

void main() {
  blocTest<EmailVerifiedBloc, EmailVerifiedState>(
    "Permet de retourner un utilisateur (Etat initial)",
    build: () {
      final profileRepository = MockProfileRepository();

      when(profileRepository.userModel).thenAnswer(
        (_) => Stream.value(null),
      );

      return EmailVerifiedBloc(
        profileRepository,
      );
    },
    expect: () => [
      EmailVerifiedInitialState(
        user: UserModel.empty(),
      ),
    ],
  );

  blocTest<EmailVerifiedBloc, EmailVerifiedState>(
    "Permet de retourner un utilisateur (initialisé)",
    build: () {
      final profileRepository = MockProfileRepository();

      return EmailVerifiedBloc(
        profileRepository,
      );
    },
    act: (bloc) => bloc.add(const OnEmailVerifiedEvent(
      user: UserModel(
        uid: "uid",
        displayName: "displayName",
        email: "email",
        emailVerified: true,
      ),
    )),
    expect: () => [
      const EmailVerifiedInitialState(
        user: UserModel(
          uid: "uid",
          displayName: "displayName",
          email: "email",
          emailVerified: true,
        ),
      ),
    ],
  );
}
