import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_scaffold_component.dart";
import "package:com_nicodevelop_dotmessenger/components/message_editor_component.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ChatScaffoldComponent(
          messages: const ChatMessageComponent(),
          editor: BlocBuilder<OpenGroupBloc, OpenGroupState>(
            builder: (context, state) {
              final Map<String, dynamic> group =
                  (state as OpenChatInitialState).group;

              return BlocListener<PostMessageBloc, PostMessageState>(
                listener: (context, state) {
                  if (state is NewGroupCreatedState) {
                    openGroup(context, {
                      ...group,
                      "uid": state.message["groupId"],
                    });
                  }
                },
                child: MessageEditorComponent(
                  onSend: (message) {
                    sendMessage(
                      context,
                      group,
                      message,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
