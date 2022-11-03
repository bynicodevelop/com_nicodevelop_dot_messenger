// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/update_profile_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:equatable/equatable.dart";

part "update_profile_event.dart";
part "update_profile_state.dart";

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  late ProfileRepository profileRepository;

  UpdateProfileBloc(
    this.profileRepository,
  ) : super(UpdateProfileInitialState()) {
    on<OnUpdateProfileEvent>((event, emit) async {
      emit(UpdateProfileLoadingState());

      try {
        await profileRepository.update(
          event.data,
        );

        emit(UpdateProfileSuccessState());
      } on UpdateProfileException catch (e) {
        warn("Update profile error", data: {
          "code": e.code,
          "message": e.message,
        });

        emit(UpdateProfileFailureState(
          code: e.code,
        ));
      } on AuthenticationException catch (e) {
        emit(UpdateProfileFailureState(
          code: e.code,
        ));
      }
    });
  }
}
