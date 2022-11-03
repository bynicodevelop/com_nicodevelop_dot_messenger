import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_scaffold_component.dart";
import "package:com_nicodevelop_dotmessenger/components/message_editor_component.dart";
import "package:flutter/material.dart";

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScaffoldComponent(
        messages: const ChatMessageComponent(),
        editor: MessageEditorComponent(
          onSend: (message) {},
        ),
      ),
    );
  }
}
