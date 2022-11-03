import "dart:async";

import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/register/register_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "register_bloc_test.mocks.dart";

void main() {
  blocTest(
    "Doit permettre de créer un profil utilisateur avec succes",
    build: () {
      final profileRepository = MockProfileRepository();

      return RegisterBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        const OnRegisterEvent(
          {
            "email": "john@domain.tld",
            "password": "password",
          },
        ),
      );
    },
    expect: () => [
      RegisterLoadingState(),
      RegisterSuccessState(),
    ],
  );

  blocTest(
    "Doit retourner une erreur losque tous les paramètres ne sont pas fournis",
    build: () {
      final profileRepository = MockProfileRepository();

      when(
        unawaited(profileRepository.register({
          "email": "john@domain.tld",
        })),
      ).thenThrow(
        const UpdateProfileException(
          "Password required",
          "password_required",
        ),
      );

      return RegisterBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        const OnRegisterEvent(
          {
            "email": "john@domain.tld",
          },
        ),
      );
    },
    expect: () => [
      RegisterLoadingState(),
      const RegisterFailureState(
        "password_required",
      ),
    ],
  );
}
