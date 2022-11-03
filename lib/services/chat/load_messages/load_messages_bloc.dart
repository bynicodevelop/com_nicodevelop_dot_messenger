// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";

part "load_messages_event.dart";
part "load_messages_state.dart";

class LoadMessagesBloc extends Bloc<LoadMessagesEvent, LoadMessagesState> {
  late ChatRepository chatRepository;

  LoadMessagesBloc(
    this.chatRepository,
  ) : super(const LoadMessagesInitialState()) {
    chatRepository.messages.listen((messages) {
      add(OnLoadedMessagesEvent(
        messages: messages,
      ));
    });

    on<OnLoadMessagesEvent>((event, emit) async {
      emit(LoadMessagesInitialState(
        loading: true,
        messages: (state as LoadMessagesInitialState).messages,
      ));

      await chatRepository.load(
        {
          "groupId": event.groupId,
        },
      );
    });
    on<OnLoadedMessagesEvent>((event, emit) async {
      emit(LoadMessagesInitialState(
        loading: false,
        messages: event.messages,
      ));
    });
  }
}
