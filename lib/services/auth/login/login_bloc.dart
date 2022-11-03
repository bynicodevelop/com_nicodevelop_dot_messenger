// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "login_event.dart";
part "login_state.dart";

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ProfileRepository profileRepository;

  LoginBloc(
    this.profileRepository,
  ) : super(LoginInitialState()) {
    on<OnLoginEvent>((event, emit) async {
      emit(LoginLoadingState());

      try {
        await profileRepository.login(
          event.data,
        );

        emit(LoginSuccessState());
      } on UpdateProfileException catch (e) {
        emit(LoginFailureState(e.code));
      }
    });
  }
}
