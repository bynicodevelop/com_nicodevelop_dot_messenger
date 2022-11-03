// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/validate_account_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "validate_account_event.dart";
part "validate_account_state.dart";

class ValidateAccountBloc
    extends Bloc<ValidateAccountEvent, ValidateAccountState> {
  late ProfileRepository profileRepository;

  ValidateAccountBloc(
    this.profileRepository,
  ) : super(ValidateAccountInitialState()) {
    on<OnValidateAccountEvent>((event, emit) async {
      emit(ValidateAccountLoadingState());

      try {
        await profileRepository.validateEmail({
          "code": event.code,
        });

        emit(ValidateAccountSuccessState());
      } on ValidateAccountException catch (e) {
        emit(ValidateAccountFailureState(
          e.code,
        ));
      } on AuthenticationException catch (e) {
        emit(ValidateAccountFailureState(
          e.code,
        ));
      }
    });
  }
}
