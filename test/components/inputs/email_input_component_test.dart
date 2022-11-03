import "package:com_nicodevelop_dotmessenger/components/inputs/email_input_component.dart";
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
              EmailInputComponent(
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
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Enter your email"), findsOneWidget);
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
              EmailInputComponent(
                controller: controller,
                label: "Email custom",
                placeholder: "Enter your email custom",
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
    expect(find.text("Email custom"), findsOneWidget);
    expect(find.text("Enter your email custom"), findsOneWidget);
  });

  testWidgets(
      "Doit verifier qu'il soit possible de mettre une valeur par défaut",
      (WidgetTester tester) async {
    // ARRANGE

    final TextEditingController controller = TextEditingController(
      text: "email@domain.tld",
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                EmailInputComponent(
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
    expect(find.text("email@domain.tld"), findsOneWidget);
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
                EmailInputComponent(
                  controller: controller,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
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
    expect(find.text("Email is required"), findsOneWidget);
  });
}
