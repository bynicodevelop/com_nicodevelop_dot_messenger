// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "delete_account_event.dart";
part "delete_account_state.dart";

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final ProfileRepository profileRepository;

  DeleteAccountBloc(
    this.profileRepository,
  ) : super(DeleteAccountInitialState()) {
    on<OnDeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoadingState());

      try {
        await profileRepository.deleteAccount();

        emit(DeleteAccountSuccessState());
      } on AuthenticationException catch (e) {
        emit(DeleteAccountFailureState(
          e.code,
        ));
      }
    });
  }
}
