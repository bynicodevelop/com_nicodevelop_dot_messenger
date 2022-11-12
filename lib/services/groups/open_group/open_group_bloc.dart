// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import 'package:com_nicodevelop_dotmessenger/services/generic_state.dart';
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:equatable/equatable.dart";

part "open_group_event.dart";
part "open_group_state.dart";

class OpenGroupBloc extends Bloc<OpenChatEvent, OpenGroupState> {
  OpenGroupBloc() : super(const OpenChatInitialState()) {
    on<OnOpenGroupEvent>((event, emit) {
      info(
        "User has select discussion with group",
        data: event.group,
      );

      emit(OpenChatInitialState(
        group: event.group,
      ));
    });
  }
}
