import "dart:async";

import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/resend_confirm_mail/resend_confirm_mail_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "resend_confirm_mail_bloc_test.mocks.dart";

void main() {
  blocTest<ResendConfirmMailBloc, ResendConfirmMailState>(
    "Doit envoyer un email avec succes",
    build: () {
      final profileRepository = MockProfileRepository();

      when(unawaited(profileRepository.resendConfirmMail()))
          .thenAnswer((_) async => true);

      return ResendConfirmMailBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        OnResendConfirmMailEvent(),
      );
    },
    expect: () => [
      ResendConfirmMailLoadingState(),
      ResendConfirmMailSuccessState(),
    ],
  );

  blocTest<ResendConfirmMailBloc, ResendConfirmMailState>(
    "Doit retourner une erreur lors de l'envoi de l'email",
    build: () {
      final profileRepository = MockProfileRepository();

      when(unawaited(profileRepository.resendConfirmMail())).thenThrow(
          const AuthenticationException("Unauthenticated", "unauthenticated"));

      return ResendConfirmMailBloc(
        profileRepository,
      );
    },
    act: (bloc) {
      bloc.add(
        OnResendConfirmMailEvent(),
      );
    },
    expect: () => [
      ResendConfirmMailLoadingState(),
      const ResendConfirmMailFailureState(
        "unauthenticated",
      ),
    ],
  );
}
