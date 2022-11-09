import "dart:async";

import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/delete_account/delete_account_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "delete_account_bloc_test.mocks.dart";

void main() {
  blocTest(
    "Doit supprimer un compte avec success",
    build: () {
      final profileRepository = MockProfileRepository();

      return DeleteAccountBloc(
        profileRepository,
      );
    },
    act: (bloc) => bloc.add(OnDeleteAccountEvent()),
    expect: () => [
      DeleteAccountLoadingState(),
      DeleteAccountSuccessState(),
    ],
  );

  blocTest(
    "Doit retourner une erreur lors de la suppression d'un compte quand l'utilisateur est déconnecté",
    build: () {
      final profileRepository = MockProfileRepository();

      when(unawaited(profileRepository.deleteAccount()))
          .thenThrow(const AuthenticationException(
        "User is not authenticated",
        "unauthenticated",
      ));

      return DeleteAccountBloc(
        profileRepository,
      );
    },
    act: (bloc) => bloc.add(OnDeleteAccountEvent()),
    expect: () => [
      DeleteAccountLoadingState(),
      const DeleteAccountFailureState(
        "unauthenticated",
      ),
    ],
  );
}
