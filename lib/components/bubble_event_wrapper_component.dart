import "package:flutter/material.dart";

class BubbleEventWrapperComponent extends StatefulWidget {
  final Map<String, dynamic> message;

  final Function(BuildContext context, Map<String, dynamic> message) builder;

  const BubbleEventWrapperComponent({
    super.key,
    required this.message,
    required this.builder,
  });

  @override
  State<BubbleEventWrapperComponent> createState() =>
      _BubbleEventWrapperComponentState();
}

class _BubbleEventWrapperComponentState
    extends State<BubbleEventWrapperComponent> {
  Widget optionDialog(BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Wrap(
          children: [
            ListTile(
              title: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  widget.message["deleted_at"] = DateTime.now();
                });
              },
            ),
            ListTile(
              title: const Text(
                "Cancel",
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        if (!widget.message["isMe"] || widget.message["deleted_at"] != null) {
          return;
        }

        showDialog(
            context: context,
            builder: (context) {
              return optionDialog(context);
            });
      },
      child: Builder(
        builder: (context) {
          return widget.builder(
            context,
            widget.message,
          );
        },
      ),
    );
  }
}
