import "package:another_flushbar/flushbar.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/material.dart";

void notice(
  BuildContext context,
  String message,
) async =>
    Flushbar(
      message: message,
      messageColor: Colors.grey[900],
      backgroundColor: Colors.white,
      duration: const Duration(
        seconds: 2,
      ),
      flushbarPosition: ResponsiveComponent.device == DeviceEnum.mobile
          ? FlushbarPosition.BOTTOM
          : FlushbarPosition.TOP,
      margin: EdgeInsets.only(
        bottom: 20.0,
        top: 20.0,
        left: ResponsiveComponent.device == DeviceEnum.mobile
            ? 20.0
            : MediaQuery.of(context).size.width * 0.6,
        right: 20.0,
      ),
      borderRadius: BorderRadius.circular(
        8.0,
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      boxShadows: [
        BoxShadow(
          color: Colors.grey[300]!,
          offset: const Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
    ).show(context);
