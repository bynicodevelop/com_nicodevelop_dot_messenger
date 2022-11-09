import "package:com_nicodevelop_dotmessenger/components/buttons/settings_button_component.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Permet de tester que le bouton appel bien la callback",
      (WidgetTester tester) async {
    bool isClicked = false;

    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: SettingsButtonComponent(
              onTap: () => isClicked = true,
            ),
          ),
        ),
      ),
    );

    // ACT
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // ASSERT
    expect(isClicked, true);
  });

  testWidgets("Permet de vérfier l'icon du bouton",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: SettingsButtonComponent(
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // ACT
    final iconFinder = find.byIcon(Icons.settings);

    // ASSERT
    expect(iconFinder, findsOneWidget);
  });
}
