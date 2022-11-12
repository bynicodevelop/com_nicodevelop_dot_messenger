import "package:com_nicodevelop_dotmessenger/components/bubble_event_wrapper_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/load_messages/load_messages_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/widgets/bubble_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:skeletons/skeletons.dart";

class ChatMessageComponent extends StatefulWidget {
  const ChatMessageComponent({super.key});

  @override
  State<ChatMessageComponent> createState() => _ChatMessageComponentState();
}

class _ChatMessageComponentState extends State<ChatMessageComponent> {
  final ScrollController _scrollController = ScrollController();

  Widget _bubbleSkeleton(
    BuildContext context,
    bool isMe,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: ResponsiveComponent.device == DeviceEnum.mobile
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 16.0,
                    right: isMe ? 16.0 : 0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 16.0,
                    right: isMe ? 16.0 : 0,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _loadingMessages(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: kIsWeb ? 100 : 5,
      ),
      shrinkWrap: true,
      children: [
        for (var i = 0; i < 5; i++)
          _bubbleSkeleton(
            context,
            // random bool
            i % 2 == 0,
          ),
      ],
    );
  }

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
            if ((state as LoadMessagesInitialState).loading) {
              return _loadingMessages(context);
            }

            final List<Map<String, dynamic>> messages = (state).messages;

            return BlocBuilder<PostMessageBloc, PostMessageState>(
              builder: (context, state) {
                /**
                 * Permet filtrer les messages en fonction de l'uid du message
                 * Permettre d'avoir une liste unique
                 * Surtout après la création d'un message
                 * Permet d'avoir le message à l'écran plus rapidement
                 */
                if (state is PostMessageSuccessState) {
                  if (!messages.any(
                      (message) => message["uid"] == state.message["uid"])) {
                    messages.add(state.message);
                  }
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: kIsWeb ? 90 : 5,
                    left: ResponsiveComponent.device != DeviceEnum.mobile
                        ? 50
                        : 10.0,
                    right: ResponsiveComponent.device != DeviceEnum.mobile
                        ? 50
                        : 10.0,
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
      },
    );
  }
}
