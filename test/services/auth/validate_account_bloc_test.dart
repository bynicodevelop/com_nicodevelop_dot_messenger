import "dart:async";

import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/validate_account_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/validate_account/validate_account_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "validate_account_bloc_test.mocks.dart";

void main() {
  blocTest<ValidateAccountBloc, ValidateAccountState>(
    "Doit retourner un success",
    build: () {
      final ProfileRepository profileRepository = MockProfileRepository();

      when(unawaited(
        profileRepository.validateEmail({
          "code": "123456",
        }),
      )).thenAnswer((_) async => true);

      return ValidateAccountBloc(
        profileRepository,
      );
    },
    act: (bloc) => bloc.add(
      const OnValidateAccountEvent(
        "123456",
      ),
    ),
    expect: () => [
      ValidateAccountLoadingState(),
      ValidateAccountSuccessState(),
    ],
  );

  blocTest<ValidateAccountBloc, ValidateAccountState>(
    "Doit retourner une erreur si le code n'est pas valide",
    build: () {
      final ProfileRepository profileRepository = MockProfileRepository();

      when(unawaited(
        profileRepository.validateEmail({
          "code": "123456",
        }),
      )).thenThrow(const ValidateAccountException(
        "Invalid code",
        "code",
      ));

      return ValidateAccountBloc(
        profileRepository,
      );
    },
    act: (bloc) => bloc.add(
      const OnValidateAccountEvent(
        "123456",
      ),
    ),
    expect: () => [
      ValidateAccountLoadingState(),
      const ValidateAccountFailureState("code"),
    ],
  );
}
