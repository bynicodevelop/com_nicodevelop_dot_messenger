import "package:com_nicodevelop_dotmessenger/components/chat_heading_bar_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_scaffold_component.dart";
import "package:com_nicodevelop_dotmessenger/components/list_group_component.dart";
import "package:com_nicodevelop_dotmessenger/components/left_column_constrained_box_component.dart";
import "package:com_nicodevelop_dotmessenger/components/message_editor_component.dart";
import "package:com_nicodevelop_dotmessenger/components/validate_account_component.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:com_nicodevelop_dotmessenger/utils/notice.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

class TabletHomeScreen extends StatelessWidget {
  const TabletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ValidateAccountComponent(
          child: Row(
            children: [
              LeftColumnConstrainedBoxComponent(
                child: BlocBuilder<ListGroupBloc, ListGroupState>(
                  builder: (context, state) {
                    final List<Map<String, dynamic>> groups =
                        (state as ListGroupInitialState).groups;

                    if (groups.isEmpty) {
                      return const Center(
                        child: Text("Aucune discussion"),
                      );
                    }

                    return ListGroupComponent(
                      groups: groups,
                      onInit: () {
                        info("Select first group from the list");

                        context.read<OpenGroupBloc>().add(OnOpenGroupEvent(
                              group: {
                                "uid": groups[0]["uid"],
                                "displayName": groups[0]["displayName"],
                                "photoUrl": groups[0]["avatarUrl"],
                              },
                            ));
                      },
                      onTap: (Map<String, dynamic> group) {
                        context.read<OpenGroupBloc>().add(OnOpenGroupEvent(
                              group: {
                                "uid": group["uid"],
                                "displayName": group["displayName"],
                                "photoUrl": group["avatarUrl"],
                              },
                            ));
                      },
                    );
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: BlocBuilder<OpenGroupBloc, OpenGroupState>(
                  builder: (context, state) {
                    final group = (state as OpenChatInitialState).group;

                    if (group.isEmpty) {
                      return const Center(
                        child: Text("Selectionnez une discussion"),
                      );
                    }

                    return ChatScaffoldComponent(
                      heading: ChatHeadingBarComponent(
                        profile: {
                          "displayName": group["displayName"],
                          "photoUrl": group["photoUrl"],
                        },
                      ),
                      messages: const ChatMessageComponent(),
                      editor: BlocListener<PostMessageBloc, PostMessageState>(
                        listener: (context, state) {
                          if (state is PostMessageFailureState) {
                            return notice(
                              context,
                              state.code,
                            );
                          }
                        },
                        child: MessageEditorComponent(
                          onSend: (message) {
                            info("Send message", data: {
                              "message": message,
                              "recipient": group["recipient"],
                              "groupId": group["uid"],
                            });

                            context.read<PostMessageBloc>().add(
                                  OnPostMessageEvent(
                                    data: {
                                      "recipient": group["recipient"],
                                      "groupId": group["uid"],
                                      "message": message,
                                    },
                                  ),
                                );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
