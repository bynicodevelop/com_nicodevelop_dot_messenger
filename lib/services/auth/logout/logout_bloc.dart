// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "logout_event.dart";
part "logout_state.dart";

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  late ProfileRepository profileRepository;

  LogoutBloc(
    this.profileRepository,
  ) : super(LogoutInitialState()) {
    on<OnLogoutEvent>((event, emit) async {
      emit(LogoutLoadingState());

      await profileRepository.logout();

      emit(LogoutSuccessState());
    });
  }
}
