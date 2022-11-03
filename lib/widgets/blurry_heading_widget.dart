import "dart:ui";

import "package:flutter/material.dart";

class BlurryHeadingWidget extends StatelessWidget {
  final Widget child;
  final double height;

  const BlurryHeadingWidget({
    super.key,
    required this.child,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}
