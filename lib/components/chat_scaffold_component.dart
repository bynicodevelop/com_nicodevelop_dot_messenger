import "package:com_nicodevelop_dotmessenger/widgets/blurry_heading_widget.dart";
import "package:flutter/material.dart";

class ChatScaffoldComponent extends StatelessWidget {
  final Widget? heading;
  final Widget messages;
  final Widget editor;

  const ChatScaffoldComponent({
    super.key,
    this.heading,
    required this.messages,
    required this.editor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 85.0,
            ),
            child: messages,
          ),
          if (heading != null)
            Row(
              children: [
                Expanded(
                  child: BlurryHeadingWidget(
                    child: heading!,
                  ),
                ),
              ],
            ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: editor,
            ),
          )
        ],
      ),
    );
  }
}
