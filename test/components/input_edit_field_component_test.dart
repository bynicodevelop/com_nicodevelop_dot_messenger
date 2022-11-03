import "package:com_nicodevelop_dotmessenger/components/input_edit_field_component.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Doit afficher le contenu du controller", (
    WidgetTester tester,
  ) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController(
      text: "Nicolas",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputEditFieldComponent(
            label: "Nom d'affichage",
            controller: controller,
            onSave: () {},
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text("Nicolas"), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets("Doit afficher le TextField si le champs n'est pas rensigné", (
    WidgetTester tester,
  ) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputEditFieldComponent(
            label: "Nom d'affichage",
            controller: controller,
            onSave: () {},
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text("Nom d'affichage"), findsOneWidget);
  });

  testWidgets("Doit permettre l'édition du contenu d'un controller", (
    WidgetTester tester,
  ) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController(
      text: "Nicolas",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputEditFieldComponent(
            label: "Nom d'affichage",
            controller: controller,
            onSave: () {},
          ),
        ),
      ),
    );

    // ACT
    final Finder editButton = find.byIcon(Icons.edit);

    await tester.tap(editButton);

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets(
      "Doit permettre l'édition du contenu d'un controller et de l'enregistrer",
      (
    WidgetTester tester,
  ) async {
    // ARRANGE
    bool saved = false;

    final TextEditingController controller = TextEditingController(
      text: "Nicolas",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: InputEditFieldComponent(
            label: "Nom d'affichage",
            controller: controller,
            onSave: () => saved = true,
          ),
        ),
      ),
    );

    // ACT
    final Finder editButton = find.byIcon(Icons.edit);
    await tester.tap(editButton);

    await tester.pumpAndSettle();

    final Finder textField = find.byType(TextField);
    await tester.enterText(textField, "Nicolas2");

    final Finder saveButton = find.byIcon(Icons.save);
    await tester.tap(saveButton);

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.text("Nicolas2"), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(saved, isTrue);
  });
}
