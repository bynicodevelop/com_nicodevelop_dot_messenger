import "package:flutter/material.dart";

class InputDecoratorWidget extends StatelessWidget {
  final Widget child;

  const InputDecoratorWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: child,
    );
  }
}
