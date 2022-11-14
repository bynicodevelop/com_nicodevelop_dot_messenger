import "package:flutter/material.dart";

class SelectedDiscussionWrapperWidget extends StatelessWidget {
  final Map<String, dynamic> group;
  final Widget child;
  final String? message;

  const SelectedDiscussionWrapperWidget({
    super.key,
    required this.group,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return group.isEmpty
        ? Center(
            child: Text(message ?? "Selectionnez une discussion"),
          )
        : child;
  }
}
