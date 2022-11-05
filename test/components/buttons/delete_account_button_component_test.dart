import "package:com_nicodevelop_dotmessenger/components/buttons/delete_account_button_component.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/delete_account/delete_account_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "delete_account_button_component_test.mocks.dart";

void main() {
  testWidgets(
      "Doit permettre d'afficher la boite de dialog quand l'utilisateur clique sur supprimer",
      (WidgetTester tester) async {
    // ARRANGE
    final ProfileRepository profileRepository = MockProfileRepository();

    await tester.pumpWidget(
      BlocProvider<DeleteAccountBloc>(
        create: (context) => DeleteAccountBloc(
          profileRepository,
        ),
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: DeleteAccountButtonComponent(),
            ),
          ),
        ),
      ),
    );

    // ACT
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets("Doit permettre d'annuler sa demande de suppression de compte",
      (WidgetTester tester) async {
    // ARRANGE
    bool isDeleted = false;

    final ProfileRepository profileRepository = MockProfileRepository();

    await tester.pumpWidget(
      BlocProvider<DeleteAccountBloc>(
        create: (context) => DeleteAccountBloc(
          profileRepository,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: DeleteAccountButtonComponent(
                onDeleted: () => isDeleted = true,
              ),
            ),
          ),
        ),
      ),
    );

    // ACT
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(AlertDialog), findsOneWidget);

    // ACT
    await tester.tap(find.text("Cancel"));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(AlertDialog), findsNothing);

    verifyNever(profileRepository.deleteAccount());

    expect(isDeleted, false);
  });

  testWidgets("Doit permettre de confirmer la suppression de son compte",
      (WidgetTester tester) async {
    // ARRANGE
    bool isDeleted = false;
    final ProfileRepository profileRepository = MockProfileRepository();

    await tester.pumpWidget(
      BlocProvider<DeleteAccountBloc>(
        create: (context) => DeleteAccountBloc(
          profileRepository,
        ),
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: DeleteAccountButtonComponent(
                onDeleted: () => isDeleted = true,
              ),
            ),
          ),
        ),
      ),
    );

    // ACT
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(AlertDialog), findsOneWidget);

    // ACT
    await tester.tap(find.text("Delete"));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(AlertDialog), findsNothing);

    verify(profileRepository.deleteAccount()).called(1);

    expect(isDeleted, true);
  });
}
