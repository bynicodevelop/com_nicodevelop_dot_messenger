import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ChatRepository>()])
import "helpers_test.mocks.dart";

void main() {
  group("sendMessage", () {
    testWidgets(
        "Doit contrôler les données envoyées lors de l'envoie d'un message",
        (WidgetTester tester) async {
      // ARRANGE
      final ChatRepository chatRepository = MockChatRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<PostMessageBloc>(
            create: (context) => PostMessageBloc(
              chatRepository,
            ),
            child: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return BlocListener<PostMessageBloc, PostMessageState>(
                    listener: (context, state) {},
                    child: TextButton(
                      onPressed: () => sendMessage(
                        context,
                        {
                          "uid": "groupUid",
                          "users": [
                            {
                              "currentUser": true,
                              "uid": "uid1",
                            },
                            {
                              "currentUser": false,
                              "uid": "uid2",
                            },
                          ],
                        },
                        "message",
                      ),
                      child: const Text("Send"),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.text("Send"));

      await tester.pumpAndSettle();

      // ASSERT
      verify(await chatRepository.post({
        "message": "message",
        "recipient": {
          "uid": "uid2",
          "currentUser": false,
        },
        "groupId": "groupUid",
      }));
    });
  });
}
