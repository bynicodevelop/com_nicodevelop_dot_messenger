import "package:com_nicodevelop_dotmessenger/widgets/avatar_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:network_image_mock/network_image_mock.dart";

void main() {
  testWidgets("Doit afficher une image si elle est définie",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      const String avatarUrl = "https://image.com/image.jpg";

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarWidget(
              avatarUrl: avatarUrl,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ACT
      // ASSERT
      final CircleAvatar imageNetworkFinder =
          tester.firstWidget(find.byType(CircleAvatar));

      expect(imageNetworkFinder.backgroundImage, isNotNull);

      expect(
          imageNetworkFinder.backgroundImage,
          isA<NetworkImage>().having(
            (NetworkImage image) => image.url,
            "url",
            avatarUrl,
          ));
    });
  });

  testWidgets(
      "Doit afficher les initiales de l'utilisateur sur la base du paramètre username (N)",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarWidget(
            username: "Nico",
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    final CircleAvatar imageNetworkFinder =
        tester.firstWidget(find.byType(CircleAvatar));

    expect(imageNetworkFinder.backgroundImage, isNull);

    final Text textFinder = tester.firstWidget(find.byType(Text));

    expect(textFinder.data, "N");
  });

  testWidgets(
      "Doit afficher les initiales de l'utilisateur sur la base du paramètre username (ND)",
      (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarWidget(
            username: "Nico Develop",
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    final CircleAvatar imageNetworkFinder =
        tester.firstWidget(find.byType(CircleAvatar));

    expect(imageNetworkFinder.backgroundImage, isNull);

    final Text textFinder = tester.firstWidget(find.byType(Text));

    expect(textFinder.data, "ND");
  });

  testWidgets(
      "Doit afficher l'image par défaut si avatarUrl et ne pas afficher les initiales",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      const String avatarUrl = "https://image.com/image.jpg";

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarWidget(
              username: "Nico Develop",
              avatarUrl: avatarUrl,
            ),
          ),
        ),
      );

      // ACT
      // ASSERT
      final CircleAvatar imageNetworkFinder =
          tester.firstWidget(find.byType(CircleAvatar));

      expect(
          imageNetworkFinder.backgroundImage,
          isA<NetworkImage>().having(
            (NetworkImage image) => image.url,
            "url",
            avatarUrl,
          ));

      expect(find.byType(Text), findsNothing);
    });
  });

  testWidgets("Doit afficher les initiales si l'image est empty",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // ARRANGE
      const String avatarUrl = "";

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarWidget(
              username: "Nico Develop",
              avatarUrl: avatarUrl,
            ),
          ),
        ),
      );

      // ACT
      // ASSERT
      final CircleAvatar imageNetworkFinder =
          tester.firstWidget(find.byType(CircleAvatar));

      expect(imageNetworkFinder.backgroundImage, isNull);

      final Text textFinder = tester.firstWidget(find.byType(Text));

      expect(textFinder.data, "ND");
    });
  });
}
