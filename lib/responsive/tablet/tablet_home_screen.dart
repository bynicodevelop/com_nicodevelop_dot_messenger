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
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
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
                        (state as ListGroupInitialState).results;

                    return ListGroupComponent(
                      groups: groups,
                      onInit: () => groups.isEmpty
                          ? null
                          : openGroup(
                              context,
                              groups[0],
                            ),
                      onTap: (Map<String, dynamic> group) {
                        openGroup(context, group);
                      },
                    );
                  },
                ),
              ),
              Expanded(
                flex: 4,
                child: BlocBuilder<OpenGroupBloc, OpenGroupState>(
                  builder: (context, state) {
                    final Map<String, dynamic> group =
                        (state as OpenChatInitialState).group;

                    if (group.isEmpty) {
                      return const Center(
                        child: Text("Selectionnez une discussion"),
                      );
                    }

                    final Map<String, dynamic> user = excludeCurrentUser(
                      group["users"],
                    );

                    return ChatScaffoldComponent(
                      heading: ChatHeadingBarComponent(
                        profile: {
                          "displayName": user["displayName"],
                          "photoUrl": user["photoUrl"],
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
                            sendMessage(
                              context,
                              group,
                              message,
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
