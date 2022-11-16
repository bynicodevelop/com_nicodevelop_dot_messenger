import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/desktop/desktop_home_screen.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/mobile_home_screen.dart";
import "package:com_nicodevelop_dotmessenger/responsive/tablet/tablet_home_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/notifications/initialize_notification/initialize_notification_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializeNotificationBloc,
        InitializeNotificationState>(
      bloc: context.read<InitializeNotificationBloc>()
        ..add(OnInitializeNotificationEvent()),
      listener: (context, state) {
        print(state);
      },
      child: ResponsiveComponent(
        builder: (
          BuildContext context,
          DeviceEnum device,
          BoxConstraints constraints,
        ) {
          switch (device) {
            case DeviceEnum.desktop:
              return const DesktopHomeScreen();
            case DeviceEnum.tablet:
              return const TabletHomeScreen();
            default:
              return const MobileHomeScreen();
          }
        },
      ),
    );
  }
}
