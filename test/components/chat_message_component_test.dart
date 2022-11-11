import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
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
  testWidgets("Doit afficher une liste de passe vide",
      (WidgetTester tester) async {
    // ARRANGE
    late BuildContext ctx;
    final ChatRepository chatRepository = MockChatRepository();

    when(chatRepository.load({
      "groupId": "groupId",
    })).thenAnswer((_) async => []);

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
                create: (context) => openGroupBloc,
              ),
              BlocProvider<LoadMessagesBloc>(
                create: (context) => loadMessagesBloc,
              ),
              BlocProvider<PostMessageBloc>(
                create: (context) => postMessageBloc,
              ),
            ],
            child: Builder(builder: (context) {
              ctx = context;
              return const ChatMessageComponent();
            }),
          ),
        ),
      ),
    );

    // ACT
    await tester.pumpAndSettle();

    ctx.read<OpenGroupBloc>().add(const OnOpenGroupEvent(
          group: {
            "uid": "groupId",
          },
        ));

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(BubbleWidget), findsNothing);
  });

  testWidgets("Doit afficher une liste de messages",
      (WidgetTester tester) async {
    // ARRANGE
    late BuildContext ctx;
    final ChatRepository chatRepository = MockChatRepository();

    when(chatRepository.load({
      "groupId": "groupId",
    })).thenAnswer((_) async => []);

    when(chatRepository.messages).thenAnswer(
      (_) => Stream.value([
        {
          "message": "message",
          "isMe": true,
        },
      ]),
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
                create: (context) => openGroupBloc,
              ),
              BlocProvider<LoadMessagesBloc>(
                create: (context) => loadMessagesBloc,
              ),
              BlocProvider<PostMessageBloc>(
                create: (context) => postMessageBloc,
              ),
            ],
            child: Builder(builder: (context) {
              ctx = context;
              return const ChatMessageComponent();
            }),
          ),
        ),
      ),
    );

    // ACT
    await tester.pumpAndSettle();

    ctx.read<OpenGroupBloc>().add(const OnOpenGroupEvent(
          group: {
            "uid": "groupId",
          },
        ));

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(BubbleWidget), findsWidgets);
  });
}
