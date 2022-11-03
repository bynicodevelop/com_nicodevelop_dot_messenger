// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "resend_confirm_mail_event.dart";
part "resend_confirm_mail_state.dart";

class ResendConfirmMailBloc
    extends Bloc<ResendConfirmMailEvent, ResendConfirmMailState> {
  final ProfileRepository profileRepository;

  ResendConfirmMailBloc(
    this.profileRepository,
  ) : super(ResendConfirmMailInitialState()) {
    on<OnResendConfirmMailEvent>((event, emit) async {
      emit(ResendConfirmMailLoadingState());

      try {
        await profileRepository.resendConfirmMail();

        emit(ResendConfirmMailSuccessState());
      } on AuthenticationException catch (e) {
        emit(ResendConfirmMailFailureState(
          e.code,
        ));
      }
    });
  }
}
