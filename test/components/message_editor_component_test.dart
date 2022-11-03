import "package:com_nicodevelop_dotmessenger/components/message_editor_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets(
      "Ne doit pas afficher le bouton d'envoi que si le message est vide",
      (WidgetTester tester) async {
    // ARRANGE
    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageEditorComponent(
            onSend: (p0) {},
          ),
        ),
      ),
    );

    // ACT
    final Finder sendButtonFinder = find.byIcon(Icons.arrow_upward_outlined);

    // ASSERT
    expect(sendButtonFinder, findsNothing);
  });

  testWidgets(
      "Doit pas afficher le bouton d'envoi quand le message n'est pas vide",
      (WidgetTester tester) async {
    // ARRANGE
    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageEditorComponent(
            onSend: (p0) {},
          ),
        ),
      ),
    );

    // ACT
    final Finder textFieldFinder = find.byType(TextField);

    await tester.enterText(textFieldFinder, "Hello");

    await tester.pumpAndSettle();

    final Finder sendButtonFinder = find.byIcon(Icons.arrow_upward_outlined);

    // ASSERT
    expect(sendButtonFinder, findsOneWidget);
  });

  testWidgets(
      "Doit pas afficher le bouton d'envoi quand le message n'est pas vide et doit être cliquable",
      (WidgetTester tester) async {
    // ARRANGE
    ResponsiveComponent.device = DeviceEnum.mobile;
    bool sendButtonClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageEditorComponent(
            onSend: (String message) {
              sendButtonClicked = true;
            },
          ),
        ),
      ),
    );

    // ACT
    final Finder textFieldFinder = find.byType(TextField);

    await tester.enterText(textFieldFinder, "Hello");

    await tester.pumpAndSettle();

    final Finder sendButtonFinder = find.byIcon(Icons.arrow_upward_outlined);

    await tester.tap(sendButtonFinder);

    await tester.pumpAndSettle();

    // ASSERT
    expect(sendButtonClicked, true);
  });

  testWidgets("Doit vider le champs texte quand le bouton d'envoi est cliqué",
      (WidgetTester tester) async {
    // ARRANGE
    ResponsiveComponent.device = DeviceEnum.mobile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageEditorComponent(
            onSend: (String message) {},
          ),
        ),
      ),
    );

    // ACT
    final Finder textFieldFinder = find.byType(TextField);

    await tester.enterText(textFieldFinder, "Hello");

    await tester.pumpAndSettle();

    final Finder sendButtonFinder = find.byIcon(Icons.arrow_upward_outlined);

    await tester.tap(sendButtonFinder);

    await tester.pumpAndSettle();

    final Finder textFieldFinderEmpty = find.byType(TextField);
    final TextField textField = tester.widget(textFieldFinderEmpty);

    // ASSERT
    expect(textField.controller!.text, "");
  });
}
