import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/components/skeletons/chat_skeletons_component.dart";
import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/load_messages/load_messages_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/widgets/bubble_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ChatRepository>()])
import "chat_message_component_test.mocks.dart";

void main() {
  testWidgets("Doit afficher une liste de message vide",
      (WidgetTester tester) async {
    // ARRANGE
    final ChatRepository chatRepository = MockChatRepository();

    when(chatRepository.messages).thenAnswer(
      (_) => Stream.value([]),
    );

    final OpenGroupBloc openGroupBloc = OpenGroupBloc();

    final LoadMessagesBloc loadMessagesBloc = LoadMessagesBloc(
      chatRepository,
    );

    final PostMessageBloc postMessageBloc = PostMessageBloc(
      chatRepository,
    );

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<OpenGroupBloc>(
                create: (context) => openGroupBloc
                  ..add(const OnOpenGroupEvent(
                    group: {
                      "uid": "groupId",
                    },
                  )),
              ),
              BlocProvider<LoadMessagesBloc>(
                create: (context) => loadMessagesBloc,
              ),
              BlocProvider<PostMessageBloc>(
                create: (context) => postMessageBloc,
              ),
            ],
            child: Builder(builder: (context) {
              return const ChatMessageComponent();
            }),
          ),
        ),
      ),
    );

    // ACT
    await tester.pump(const Duration(seconds: 1));

    // ASSERT
    expect(find.text("No messages found"), findsOneWidget);
  });

  testWidgets("Doit afficher un status de chargement",
      (WidgetTester tester) async {
    // ARRANGE
    final ChatRepository chatRepository = MockChatRepository();

    when(chatRepository.messages).thenAnswer(
      (_) => Stream.value([]),
    );

    final OpenGroupBloc openGroupBloc = OpenGroupBloc();

    final LoadMessagesBloc loadMessagesBloc = LoadMessagesBloc(
      chatRepository,
    );

    final PostMessageBloc postMessageBloc = PostMessageBloc(
      chatRepository,
    );

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<OpenGroupBloc>(
                create: (context) => openGroupBloc
                  ..add(const OnOpenGroupEvent(
                    group: {
                      "uid": "groupId",
                    },
                  )),
              ),
              BlocProvider<LoadMessagesBloc>(
                create: (context) => loadMessagesBloc
                  ..emit(const LoadMessagesInitialState(
                    loading: true,
                    results: [],
                  )),
              ),
              BlocProvider<PostMessageBloc>(
                lazy: false,
                create: (context) => postMessageBloc,
              ),
            ],
            child: Builder(builder: (context) {
              return const ChatMessageComponent();
            }),
          ),
        ),
      ),
    );

    // ACT
    await tester.pump(const Duration(seconds: 1));

    // ASSERT
    expect(find.byType(ChatSkeletonComponent), findsOneWidget);
    expect(find.byType(BubbleWidget), findsNothing);
  });

  testWidgets("Doit afficher une liste de messages",
      (WidgetTester tester) async {
    // ARRANGE
    final ChatRepository chatRepository = MockChatRepository();

    final OpenGroupBloc openGroupBloc = OpenGroupBloc();

    final LoadMessagesBloc loadMessagesBloc = LoadMessagesBloc(
      chatRepository,
    );

    final PostMessageBloc postMessageBloc = PostMessageBloc(
      chatRepository,
    );

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider<OpenGroupBloc>(
                create: (context) => openGroupBloc
                  ..add(const OnOpenGroupEvent(
                    group: {
                      "uid": "groupId",
                    },
                  )),
              ),
              BlocProvider<LoadMessagesBloc>(
                create: (context) => loadMessagesBloc
                  ..emit(const LoadMessagesInitialState(
                    loading: false,
                    results: [
                      {
                        "message": "message",
                        "isMe": true,
                      },
                    ],
                  )),
              ),
              BlocProvider<PostMessageBloc>(
                lazy: false,
                create: (context) => postMessageBloc,
              ),
            ],
            child: Builder(builder: (context) {
              return const ChatMessageComponent();
            }),
          ),
        ),
      ),
    );

    // ACT
    await tester.pump(const Duration(seconds: 1));

    // ASSERT
    expect(find.byType(BubbleWidget), findsWidgets);
  });
}
