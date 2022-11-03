import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("ResponsiveComponent", () {
    testWidgets("should render the mobile layout when the screen is small",
        (WidgetTester tester) async {
      final responsiveComponent = ResponsiveComponent(
        builder: (context, device, constraints) {
          if (device == DeviceEnum.mobile) {
            return const Text("Mobile");
          }

          return const Text("Not Mobile");
        },
      );

      // Create screen size smaller than 600
      tester.binding.window.physicalSizeTestValue = const Size(300, 600);

      // Force the screen to update
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      // Rebuild the widget after the screen size has changed
      await tester.pumpWidget(MaterialApp(home: responsiveComponent));

      // Verify that the mobile layout is rendered
      expect(find.text("Mobile"), findsOneWidget);
    });

    testWidgets("should render the mobile layout when the screen is small 600",
        (WidgetTester tester) async {
      final responsiveComponent = ResponsiveComponent(
        builder: (context, device, constraints) {
          if (device == DeviceEnum.mobile) {
            return const Text("Mobile");
          }

          return const Text("Not Mobile");
        },
      );

      // Create screen size smaller than 600
      tester.binding.window.physicalSizeTestValue = const Size(600, 600);

      // Force the screen to update
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      // Rebuild the widget after the screen size has changed
      await tester.pumpWidget(MaterialApp(home: responsiveComponent));

      // Verify that the mobile layout is rendered
      expect(find.text("Mobile"), findsOneWidget);
    });

    testWidgets("should render the tablet layout when the screen is small",
        (WidgetTester tester) async {
      final responsiveComponent = ResponsiveComponent(
        builder: (context, device, constraints) {
          if (device == DeviceEnum.tablet) {
            return const Text("Tablet");
          }

          return const Text("Not Tablet");
        },
      );

      // Create screen size smaller than 600
      tester.binding.window.physicalSizeTestValue = const Size(601, 600);

      // Force the screen to update
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      // Rebuild the widget after the screen size has changed
      await tester.pumpWidget(MaterialApp(home: responsiveComponent));

      // Verify that the mobile layout is rendered
      expect(find.text("Tablet"), findsOneWidget);
    });

    testWidgets("should render the tablet layout when the screen is small 1199",
        (WidgetTester tester) async {
      final responsiveComponent = ResponsiveComponent(
        builder: (context, device, constraints) {
          if (device == DeviceEnum.tablet) {
            return const Text("Tablet");
          }

          return const Text("Not Tablet");
        },
      );

      // Create screen size smaller than 600
      tester.binding.window.physicalSizeTestValue = const Size(1199, 600);

      // Force the screen to update
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      // Rebuild the widget after the screen size has changed
      await tester.pumpWidget(MaterialApp(home: responsiveComponent));

      // Verify that the mobile layout is rendered
      expect(find.text("Tablet"), findsOneWidget);
    });

    testWidgets("should render the desktop layout when the screen is small",
        (WidgetTester tester) async {
      final responsiveComponent = ResponsiveComponent(
        builder: (context, device, constraints) {
          if (device == DeviceEnum.desktop) {
            return const Text("Desktop");
          }

          return const Text("Not Desktop");
        },
      );

      // Create screen size smaller than 600
      tester.binding.window.physicalSizeTestValue = const Size(1201, 600);

      // Force the screen to update
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      // Rebuild the widget after the screen size has changed
      await tester.pumpWidget(MaterialApp(home: responsiveComponent));

      // Verify that the mobile layout is rendered
      expect(find.text("Desktop"), findsOneWidget);
    });
  });
}
