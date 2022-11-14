import "package:com_nicodevelop_dotmessenger/components/chat_heading_bar_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_message_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_scaffold_component.dart";
import "package:com_nicodevelop_dotmessenger/components/left_column_constrained_box_component.dart";
import "package:com_nicodevelop_dotmessenger/components/list_group_component.dart";
import "package:com_nicodevelop_dotmessenger/components/message_editor_component.dart";
import "package:com_nicodevelop_dotmessenger/components/skeletons/groups_skeletons_component.dart";
import "package:com_nicodevelop_dotmessenger/components/validate_account_component.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:com_nicodevelop_dotmessenger/widgets/selected_discussion_wrapper_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ValidateAccountComponent(
          child: Row(
            children: [
              LeftColumnConstrainedBoxComponent(
                minWidth: 350,
                child: BlocBuilder<ListGroupBloc, ListGroupState>(
                  builder: (context, state) {
                    final List<Map<String, dynamic>> groups =
                        (state as ListGroupInitialState).results;

                    if (groups.isEmpty && !state.loading) {
                      return const Center(
                        child: Text("No groups"),
                      );
                    }

                    return GroupSkeletonsComponent(
                      isLoading: state.loading,
                      child: ListGroupComponent(
                        onInit: () => openGroup(
                          context,
                          groups[0],
                        ),
                        groups: groups,
                        onTap: (group) => openGroup(
                          context,
                          group,
                        ),
                      ),
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

                    return SelectedDiscussionWrapperWidget(
                      group: group,
                      child: Builder(
                        builder: (context) {
                          return ChatScaffoldComponent(
                            messages: const ChatMessageComponent(),
                            editor: Builder(
                              builder: (context) {
                                return MessageEditorComponent(
                                  onSend: (message) {
                                    sendMessage(
                                      context,
                                      group,
                                      message,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    BlocBuilder<OpenGroupBloc, OpenGroupState>(
                      builder: (context, state) {
                        final Map<String, dynamic> group =
                            (state as OpenChatInitialState).group;

                        if (group.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final Map<String, dynamic> user =
                            excludeCurrentUser(group["users"]);

                        return ChatHeadingBarComponent(
                          profile: {
                            "displayName": user["displayName"],
                            "photoUrl": user["photoUrl"],
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
