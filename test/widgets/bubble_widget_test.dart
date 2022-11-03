import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/widgets/bubble_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Doit afficher ses messages personnels",
      (WidgetTester tester) async {
    // ARRANGE
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: true,
            deletedAt: null,
          ),
        ),
      ),
    );

    // ACT
    final textFinder = find.text("Hello");

    // ASSERT
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Doit afficher les messages des autres",
      (WidgetTester tester) async {
    // ARRANGE
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: false,
            deletedAt: null,
          ),
        ),
      ),
    );

    // ACT
    final textFinder = find.text("Hello");

    // ASSERT
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Doit afficher un message comme quoi le message est effacé",
      (WidgetTester tester) async {
    // ARRANGE
    // Minimim size of the screen
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: true,
            deletedAt: DateTime.now(),
          ),
        ),
      ),
    );

    // ACT
    final textFinder = find.text("This message was deleted");

    // ASSERT
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Ne doit pas afficher les messags effacés des autres",
      (WidgetTester tester) async {
    // ARRANGE
    // Minimim size of the screen
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: false,
            deletedAt: DateTime.now(),
          ),
        ),
      ),
    );

    // ACT
    final textFinder = find.text("This message was deleted");

    // ASSERT
    expect(textFinder, findsNothing);
  });

  testWidgets("Doit afficher les messages personnels à droite",
      (WidgetTester tester) async {
    // ARRANGE
    // Minimim size of the screen
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: true,
            deletedAt: null,
          ),
        ),
      ),
    );

    // ACT
    final Finder rowFinder = find.byType(Row);

    // ASSERT
    expect(
      (rowFinder.evaluate().first.widget as Row).mainAxisAlignment,
      MainAxisAlignment.end,
    );
  });

  testWidgets("Doit afficher les messages des autres à gauche",
      (WidgetTester tester) async {
    // ARRANGE
    // Minimim size of the screen
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);

    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BubbleWidget(
            message: "Hello",
            isMe: false,
            deletedAt: null,
          ),
        ),
      ),
    );

    // ACT
    final Finder rowFinder = find.byType(Row);

    // ASSERT
    expect(
      (rowFinder.evaluate().first.widget as Row).mainAxisAlignment,
      MainAxisAlignment.start,
    );
  });
}
