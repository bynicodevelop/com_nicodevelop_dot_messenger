import "dart:async";

import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/login/login_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "login_bloc_test.mocks.dart";

void main() {
  blocTest(
    "Doit permettre de lancer une procédure d'enregistrement avec succes",
    build: () {
      final profileRepository = MockProfileRepository();

      return LoginBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(const OnLoginEvent(
        {
          "email": "john@domain.tld",
          "password": "password",
        },
      ));
    },
    expect: () => [
      LoginLoadingState(),
      LoginSuccessState(),
    ],
  );

  blocTest(
    "Doit retourner une erreur losque tous les paramètres ne sont pas fournis",
    build: () {
      final profileRepository = MockProfileRepository();

      when(
        unawaited(profileRepository.login(
          {
            "email": "john@domain.tld",
          },
        )),
      ).thenThrow(
        const UpdateProfileException(
          "Password required",
          "password_required",
        ),
      );

      return LoginBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(const OnLoginEvent(
        {
          "email": "john@domain.tld",
        },
      ));
    },
    expect: () => [
      LoginLoadingState(),
      const LoginFailureState(
        "password_required",
      ),
    ],
  );
}
