import "dart:io";

import "package:com_nicodevelop_dotmessenger/components/bubble_event_wrapper_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/load_messages/load_messages_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/widgets/bubble_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ChatMessageComponent extends StatefulWidget {
  const ChatMessageComponent({super.key});

  @override
  State<ChatMessageComponent> createState() => _ChatMessageComponentState();
}

class _ChatMessageComponentState extends State<ChatMessageComponent> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenGroupBloc, OpenGroupState>(
      builder: (context, state) {
        final Map<String, dynamic> group =
            (state as OpenChatInitialState).group;

        if (group.isEmpty) {
          return const Center(
            child: Text("Aucun groupe"),
          );
        }

        if (!group.containsKey("uid") ||
            group["uid"] == null ||
            group["uid"].isEmpty) {
          return const Center(
            child: Text("New group"),
          );
        }

        return BlocBuilder<LoadMessagesBloc, LoadMessagesState>(
          bloc: context.read<LoadMessagesBloc>()
            ..add(OnLoadMessagesEvent(
              groupId: group["uid"],
            )),
          builder: (context, state) {
            final List<Map<String, dynamic>> messages =
                (state as LoadMessagesInitialState).messages;

            return ListView.builder(
              padding: EdgeInsets.only(
                top: kIsWeb
                    ? 90
                    : Platform.isIOS
                        ? 150
                        : 110,
                left:
                    ResponsiveComponent.device != DeviceEnum.mobile ? 50 : 10.0,
                right:
                    ResponsiveComponent.device != DeviceEnum.mobile ? 50 : 10.0,
              ),
              reverse: true,
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return BubbleEventWrapperComponent(
                  message: messages[index],
                  builder: (context, message) {
                    return BubbleWidget(
                      message: message["message"],
                      isMe: message["isMe"],
                      deletedAt: message["deleted_at"],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
