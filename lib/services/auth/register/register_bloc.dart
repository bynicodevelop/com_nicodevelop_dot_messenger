// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:equatable/equatable.dart";

part "register_event.dart";
part "register_state.dart";

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ProfileRepository profileRepository;

  RegisterBloc(
    this.profileRepository,
  ) : super(RegisterInitialState()) {
    on<OnRegisterEvent>((event, emit) async {
      emit(RegisterLoadingState());

      try {
        await profileRepository.register(
          event.data,
        );

        emit(RegisterSuccessState());
      } on UpdateProfileException catch (e) {
        emit(RegisterFailureState(
          e.code,
        ));
      }
    });
  }
}
