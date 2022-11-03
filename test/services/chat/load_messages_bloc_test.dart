import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/load_messages/load_messages_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ChatRepository>()])
import "load_messages_bloc_test.mocks.dart";

void main() {
  group("OnLoadMessagesBloc", () {
    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });

    blocTest<LoadMessagesBloc, LoadMessagesState>(
      "Doit appeler la méthode load du repository avec un id de groupe",
      build: () {
        return LoadMessagesBloc(
          chatRepository,
        );
      },
      act: (bloc) async {
        bloc.add(const OnLoadMessagesEvent(
          groupId: "1",
        ));
      },
      expect: () => [
        const LoadMessagesInitialState(
          loading: true,
          messages: [],
        ),
      ],
      verify: (bloc) async {
        verify(chatRepository.load(
          {
            "groupId": "1",
          },
        )).called(1);
      },
    );
  });

  group("OnLoadedMessagesBloc", () {
    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });

    blocTest<LoadMessagesBloc, LoadMessagesState>(
      "Doit permettre le chargement des messages (avec des messages)",
      build: () {
        return LoadMessagesBloc(
          chatRepository,
        );
      },
      act: (bloc) {
        bloc.add(const OnLoadedMessagesEvent(
          messages: [
            {
              "message": "message content",
              "isMe": false,
              "deleted_at": null,
            }
          ],
        ));
      },
      expect: () => [
        const LoadMessagesInitialState(
          loading: false,
          messages: [
            {
              "message": "message content",
              "isMe": false,
              "deleted_at": null,
            }
          ],
        ),
      ],
    );

    blocTest<LoadMessagesBloc, LoadMessagesState>(
      "Doit permettre le chargement des messages (sans messages)",
      build: () {
        return LoadMessagesBloc(
          chatRepository,
        );
      },
      act: (bloc) {
        bloc.add(const OnLoadedMessagesEvent(
          messages: [],
        ));
      },
      expect: () => [
        const LoadMessagesInitialState(
          loading: false,
          messages: [],
        ),
      ],
    );
  });
}
