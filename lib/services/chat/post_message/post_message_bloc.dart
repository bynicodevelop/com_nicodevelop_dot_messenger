// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/chat_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:equatable/equatable.dart";

part "post_message_event.dart";
part "post_message_state.dart";

class PostMessageBloc extends Bloc<PostMessageEvent, PostMessageState> {
  final ChatRepository chatRepository;

  PostMessageBloc(
    this.chatRepository,
  ) : super(PostMessageInitialState()) {
    on<OnPostMessageEvent>((event, emit) async {
      emit(PostMessageLoadingState());

      try {
        final Map<String, dynamic> postResult = await chatRepository.post({
          "groupId": event.data["groupId"],
          "message": event.data["message"],
          "recipient": event.data["recipient"],
        });

        if (postResult["groupId"] != event.data["groupId"]) {
          emit(NewGroupCreatedState(
            message: {
              "uid": postResult["uid"],
              "message": event.data["message"],
              "groupId": postResult["groupId"],
            },
          ));
        } else {
          emit(PostMessageSuccessState(
            message: postResult,
          ));
        }
      } on ChatException catch (e) {
        emit(PostMessageFailureState(
          code: e.code,
        ));
      } on AuthenticationException catch (e) {
        emit(PostMessageFailureState(
          code: e.code,
        ));
      }
    });
  }
}
