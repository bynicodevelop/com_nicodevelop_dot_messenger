import "package:com_nicodevelop_dotmessenger/components/inputs/password_input_component.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("Doit permettre de configurer les options d'un input",
      (WidgetTester tester) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PasswordInputComponent(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    ));

    // ACT
    final Finder emailInput = find.byType(TextFormField);

    // ASSERT
    expect(emailInput, findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.text("Enter your password"), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  testWidgets("Doit vérifier que les options sont paramétrables",
      (WidgetTester tester) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PasswordInputComponent(
                controller: controller,
                label: "Password custom",
                placeholder: "Enter your password custom",
              ),
            ],
          ),
        ),
      ),
    ));

    // ACT
    final Finder emailInput = find.byType(TextFormField);

    // ASSERT
    expect(emailInput, findsOneWidget);
    expect(find.text("Password custom"), findsOneWidget);
    expect(find.text("Enter your password custom"), findsOneWidget);
  });

  testWidgets(
      "Doit verifier qu'il soit possible de mettre une valeur par défaut",
      (WidgetTester tester) async {
    // ARRANGE

    final TextEditingController controller = TextEditingController(
      text: "123456",
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                PasswordInputComponent(
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    // ACT
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.text("123456"), findsOneWidget);
  });

  testWidgets("Doit afficher une erreur si le champ est vide",
      (WidgetTester tester) async {
    // ARRANGE
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                PasswordInputComponent(
                  controller: controller,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }

                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    ));

    // ACT
    await tester.enterText(find.byType(TextFormField), "");

    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.text("Password is required"), findsOneWidget);
  });

  testWidgets("Doit afficher le mot de passe en clair",
      (WidgetTester tester) async {
    // ARRANGE
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              PasswordInputComponent(
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    ));

    // ACT
    await tester.tap(find.byIcon(Icons.visibility_off));

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });
}
