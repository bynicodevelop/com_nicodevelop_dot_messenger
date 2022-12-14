import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/components/validate_account_component.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/email_verified/email_verified_bloc.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<ProfileRepository>()])
import "validate_account_component_test.mocks.dart";

void main() {
  testWidgets("Message validate account is visible",
      (WidgetTester tester) async {
    final MockUser user = MockUser(
      isAnonymous: false,
      uid: "123456789",
      email: "john@domain.tld",
      isEmailVerified: false,
    );

    MockFirebaseAuth(
      signedIn: true,
      mockUser: user,
    );

    final ProfileRepository profileRepository = MockProfileRepository();

    when(profileRepository.userModel).thenAnswer(
      (_) => Stream.value(UserModel.fromMap({
        "uid": user.uid,
        "displayName": user.displayName,
        "email": user.email,
        "emailVerified": user.emailVerified,
      })),
    );

    // ARRAGE
    await tester.pumpWidget(MaterialApp(
      home: ResponsiveComponent(builder: (
        BuildContext context,
        DeviceEnum device,
        BoxConstraints constraints,
      ) {
        return Scaffold(
          body: BlocProvider<EmailVerifiedBloc>(
            create: (context) => EmailVerifiedBloc(
              profileRepository,
            ),
            child: const ValidateAccountComponent(
              child: SizedBox(
                width: 100,
                height: 100,
              ),
            ),
          ),
        );
      }),
    ));

    // ACT
    await tester.pumpAndSettle();

    // ASSERT
    final Finder textFinder = find.text("Account is not validated");
    expect(textFinder, findsOneWidget);
  });

  testWidgets("Message validate account isn't visible",
      (WidgetTester tester) async {
    final MockUser user = MockUser(
      isEmailVerified: true,
      email: "john@domain.tld",
      displayName: "John Doe",
    );

    MockFirebaseAuth(
      signedIn: true,
      mockUser: user,
    );

    final ProfileRepository profileRepository = MockProfileRepository();

    when(profileRepository.userModel).thenAnswer(
      (_) => Stream.value(UserModel.fromMap({
        "uid": user.uid,
        "displayName": user.displayName,
        "email": user.email,
        "emailVerified": user.emailVerified,
      })),
    );

    // ARRAGE
    await tester.pumpWidget(MaterialApp(
      home: ResponsiveComponent(builder: (
        BuildContext context,
        DeviceEnum device,
        BoxConstraints constraints,
      ) {
        return Scaffold(
          body: BlocProvider<EmailVerifiedBloc>(
            create: (context) => EmailVerifiedBloc(
              profileRepository,
            ),
            child: const ValidateAccountComponent(
              child: SizedBox(
                width: 100,
                height: 100,
              ),
            ),
          ),
        );
      }),
    ));

    // ACT
    await tester.pumpAndSettle();

    // ASSERT
    final Finder textFinder = find.text("Account is not validated");
    expect(textFinder, findsNothing);
  });
}
