import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/material.dart";

class BubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime? deletedAt;

  const BubbleWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.deletedAt,
  });

  double _calculateWidth(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (ResponsiveComponent.device == DeviceEnum.mobile) {
      return width * 0.6;
    }

    if (width > 700 && width < 900) {
      return width * 0.4;
    }

    if (width > 900) {
      return width * 0.3;
    }

    return 180;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeleted = deletedAt != null;

    final String msg = isDeleted ? "This message was deleted" : message;

    if (isDeleted && !isMe) {
      return const SizedBox.shrink();
    }

    Color fontColor = Theme.of(context).textTheme.bodyText1!.color!;
    Color color = isMe ? Colors.blue[200]! : Colors.grey[200]!;

    if (isDeleted) {
      color = color.withOpacity(0.3);
      fontColor = fontColor.withOpacity(0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              maxWidth: _calculateWidth(context),
            ),
            child: Text(
              msg,
              style: TextStyle(
                fontSize: 16,
                fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                color: fontColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
