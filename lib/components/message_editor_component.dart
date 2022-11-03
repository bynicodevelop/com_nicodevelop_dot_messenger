import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:flutter/material.dart";

class MessageEditorComponent extends StatefulWidget {
  final Function(String) onSend;

  const MessageEditorComponent({
    super.key,
    required this.onSend,
  });

  @override
  State<MessageEditorComponent> createState() => _MessageEditorComponentState();
}

class _MessageEditorComponentState extends State<MessageEditorComponent> {
  final TextEditingController _controller = TextEditingController();

  bool _sendButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() => _sendButtonEnabled = _controller.text.isNotEmpty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            ResponsiveComponent.device != DeviceEnum.mobile ? 50.0 : 10.0,
        vertical: 16.0,
      ),
      padding: const EdgeInsets.only(
        left: 22.0,
        right: 5.0,
        bottom: 5.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          if (_sendButtonEnabled)
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    80.0,
                  ),
                ),
                onTap: () {
                  widget.onSend(_controller.text);
                  _controller.clear();
                },
                child: Ink(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        80.0,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_upward_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
