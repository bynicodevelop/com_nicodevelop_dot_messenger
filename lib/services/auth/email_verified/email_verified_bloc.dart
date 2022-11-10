// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "email_verified_event.dart";
part "email_verified_state.dart";

class EmailVerifiedBloc extends Bloc<EmailVerifiedEvent, EmailVerifiedState> {
  late ProfileRepository profileRepository;

  EmailVerifiedBloc(
    this.profileRepository,
  ) : super(EmailVerifiedInitialState(
          user: UserModel.empty(),
        )) {
    profileRepository.userModel.listen((user) {
      add(OnEmailVerifiedEvent(
        user: user ?? UserModel.empty(),
      ));
    });

    on<OnEmailVerifiedEvent>((event, emit) {
      emit(EmailVerifiedInitialState(
        user: event.user,
      ));
    });
  }
}
