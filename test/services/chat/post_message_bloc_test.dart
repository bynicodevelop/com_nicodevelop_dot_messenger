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
      })).thenAnswer((_) async => {
            "messageId": "1",
            "groupId": "1",
            "message": "Hello world",
            "createdAt": "2021-01-01T00:00:00.000Z",
            "updatedAt": "2021-01-01T00:00:00.000Z",
          });

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "groupId": "1",
        "message": "Hello world",
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
      })).thenAnswer((_) async => {
            "messageId": "1",
            "groupId": "1",
            "message": "New Hello world",
            "createdAt": "2021-01-01T00:00:00.000Z",
            "updatedAt": "2021-01-01T00:00:00.000Z",
          });

      return PostMessageBloc(chatRepository);
    },
    act: (bloc) {
      bloc.add(const OnPostMessageEvent(data: {
        "message": "New Hello world",
      }));
    },
    expect: () => [
      PostMessageLoadingState(),
      NewGroupCreatedState(),
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
