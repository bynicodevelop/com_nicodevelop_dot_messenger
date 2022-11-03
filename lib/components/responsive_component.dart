import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:flutter/material.dart";

enum DeviceEnum {
  desktop,
  tablet,
  mobile,
}

class ResponsiveComponent extends StatelessWidget {
  final Function(BuildContext, DeviceEnum, BoxConstraints) builder;

  static late DeviceEnum device;

  const ResponsiveComponent({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      DeviceEnum device = DeviceEnum.mobile;

      if (constraints.maxWidth > 600) {
        device = DeviceEnum.tablet;
      }

      if (constraints.maxWidth > 1200) {
        device = DeviceEnum.desktop;
      }

      ResponsiveComponent.device = device;

      info("Device: $device");

      return builder(context, device, constraints);
    });
  }
}
