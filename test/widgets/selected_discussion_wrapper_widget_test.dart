import "package:com_nicodevelop_dotmessenger/widgets/selected_discussion_wrapper_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

main() {
  testWidgets("Doit afficher 'Selectionner une discussion'",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SelectedDiscussionWrapperWidget(
          group: {},
          child: Center(
            child: Text("discussion"),
          ),
        ),
      ),
    ));

    // ACT
    // ASSERT
    expect(find.text("Selectionnez une discussion"), findsOneWidget);
    expect(find.text("discussion"), findsNothing);
  });

  testWidgets("Doit afficher un message custom", (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SelectedDiscussionWrapperWidget(
          message: "message custom",
          group: {},
          child: Center(
            child: Text("discussion"),
          ),
        ),
      ),
    ));

    // ACT
    // ASSERT
    expect(find.text("message custom"), findsOneWidget);
    expect(find.text("Selectionnez une discussion"), findsNothing);
    expect(find.text("discussion"), findsNothing);
  });

  testWidgets("Ne doit afficher 'Selectionner une discussion'",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SelectedDiscussionWrapperWidget(
          group: {
            "uid": "uid",
          },
          child: Center(
            child: Text("discussion"),
          ),
        ),
      ),
    ));

    // ACT
    // ASSERT
    expect(find.text("Selectionnez une discussion"), findsNothing);
    expect(find.text("discussion"), findsOneWidget);
  });
}
