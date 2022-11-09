import "package:com_nicodevelop_dotmessenger/widgets/item_group_widget.dart";
import "package:timeago/timeago.dart" as timeago;
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:network_image_mock/network_image_mock.dart";

void main() {
  testWidgets("Doit vérifier que le message est non lu",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      final DateTime lastMessageTime = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemGroupWidget(
              avatarUrl: "https://www.google.com",
              displayName: "John Doe",
              lastMessage: "Hello",
              lastMessageTime: lastMessageTime,
            ),
          ),
        ),
      );

      // ACT
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.byType(CircleAvatar), findsOneWidget);

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("Hello"), findsOneWidget);
      expect(find.text(timeago.format(lastMessageTime)), findsOneWidget);

      final TextStyle styleDisplayName =
          tester.widget<Text>(find.text("John Doe")).style as TextStyle;

      final TextStyle styleLastMessage =
          tester.widget<Text>(find.text("Hello")).style as TextStyle;

      final TextStyle styleLastMessageTime =
          tester.widget<Text>(find.text("Hello")).style as TextStyle;

      expect(styleDisplayName.fontWeight, FontWeight.bold);
      expect(styleLastMessage.fontWeight, FontWeight.bold);
      expect(styleLastMessageTime.fontWeight, FontWeight.bold);
    });
  });

  testWidgets("Doit vérifier que le message est lu",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      final DateTime lastMessageTime = DateTime.now();

      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemGroupWidget(
              avatarUrl: "https://www.google.com",
              displayName: "John Doe",
              lastMessage: "Hello",
              lastMessageTime: lastMessageTime,
              isReaded: true,
            ),
          ),
        ),
      );

      // ACT
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.byType(CircleAvatar), findsOneWidget);

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("Hello"), findsOneWidget);
      expect(find.text(timeago.format(lastMessageTime)), findsOneWidget);

      // get style of text
      final TextStyle styleDisplayName =
          tester.widget<Text>(find.text("John Doe")).style as TextStyle;

      final TextStyle styleLastMessage =
          tester.widget<Text>(find.text("Hello")).style as TextStyle;

      final TextStyle styleLastMessageTime =
          tester.widget<Text>(find.text("Hello")).style as TextStyle;

      // check if text is bold
      expect(styleDisplayName.fontWeight, FontWeight.normal);
      expect(styleLastMessage.fontWeight, FontWeight.normal);
      expect(styleLastMessageTime.fontWeight, FontWeight.normal);
    });
  });

  testWidgets("Doit permettre d'être cliquable", (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      final DateTime lastMessageTime = DateTime.now();
      bool isClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemGroupWidget(
              avatarUrl: "https://www.google.com",
              displayName: "John Doe",
              lastMessage: "Hello",
              lastMessageTime: lastMessageTime,
              onTap: () => isClicked = true,
            ),
          ),
        ),
      );

      // ACT
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ItemGroupWidget));
      await tester.pumpAndSettle();

      // ASSERT
      expect(isClicked, true);
    });
  });
}
