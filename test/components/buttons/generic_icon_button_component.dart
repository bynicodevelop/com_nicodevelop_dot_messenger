import 'package:com_nicodevelop_dotmessenger/components/buttons/generic_icon_button_component.dart';
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Permet de vérfier que les paramètre sont renseignés",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: GenericIconButtonComponent(
              icon: Icons.add,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    // ACT
    final iconFinder = find.byIcon(Icons.add);

    // ASSERT
    expect(iconFinder, findsOneWidget);
  });

  testWidgets("Doit vérifier que la callback est appelée",
      (WidgetTester tester) async {
    bool isClicked = false;

    // ARRANGE
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            height: 300,
            child: GenericIconButtonComponent(
              icon: Icons.add,
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
}
