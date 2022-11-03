import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/logout/logout_bloc.dart";
import "package:mockito/annotations.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "logout_bloc_test.mocks.dart";

void main() {
  blocTest<LogoutBloc, LogoutState>(
    "Doit permettre la déconnexion avec success",
    build: () {
      final ProfileRepository profileRepository = MockProfileRepository();

      return LogoutBloc(
        profileRepository,
      );
    },
    act: (LogoutBloc bloc) {
      bloc.add(OnLogoutEvent());
    },
    expect: () => [
      LogoutLoadingState(),
      LogoutSuccessState(),
    ],
  );
}
