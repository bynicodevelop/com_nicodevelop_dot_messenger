import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/chat_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ChatRepository>()])
import "post_message_bloc_test.mocks.dart";

void main() {
  blocTest(
    "Doit permettre la création d'un nouveau message dans un groupe existant",
    build: () {
      final chatRepository = MockChatRepository();

      // ignore: discarded_futures
      when(chatRepository.post({
        "groupId": "1",
        "message": "Hello world",
        "recipient": {},
      })).thenAnswer((_) async => {
            "groupId": "1",
          });

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "groupId": "1",
        "message": "Hello world",
        "recipient": {},
      }));
    },
    expect: () => [
      PostMessageLoadingState(),
      PostMessageSuccessState(),
    ],
  );

  blocTest(
    "Doit permettre la création d'un nouveau message et d'un groupe",
    build: () {
      final chatRepository = MockChatRepository();

      // ignore: discarded_futures
      when(chatRepository.post({
        "message": "New Hello world",
        "recipient": {},
        "groupId": "",
      })).thenAnswer((_) async => {
            "groupId": "1",
          });

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "message": "New Hello world",
        "groupId": "",
        "recipient": {},
      }));
    },
    expect: () => [
      PostMessageLoadingState(),
      const NewGroupCreatedState(
        groupId: "1",
      ),
    ],
  );

  blocTest(
    "Doit retourner une erreur lors de la création d'un nouveau message",
    build: () {
      final chatRepository = MockChatRepository();

      // ignore: discarded_futures
      when(chatRepository.post({
        "groupId": "1",
        "message": "",
        "recipient": {},
      })).thenThrow(const ChatException(
        "Message is required",
        "message_required",
      ));

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "groupId": "1",
        "message": "",
        "recipient": {},
      }));
    },
    expect: () => [
      PostMessageLoadingState(),
      const PostMessageFailureState(
        code: "message_required",
      ),
    ],
  );

  blocTest(
    "Doit retourner une erreur lors de l'envoi d'un message avec un utilisateur non connecté",
    build: () {
      final chatRepository = MockChatRepository();

      // ignore: discarded_futures
      when(chatRepository.post({
        "groupId": "1",
        "message": "Hello world",
        "recipient": {},
      })).thenThrow(const AuthenticationException(
        "User is not connected",
        "unauthenticated",
      ));

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "groupId": "1",
        "message": "Hello world",
        "recipient": {},
      }));
    },
    expect: () => [
      PostMessageLoadingState(),
      const PostMessageFailureState(
        code: "unauthenticated",
      ),
    ],
  );
}
