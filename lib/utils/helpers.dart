import "package:com_nicodevelop_dotmessenger/services/chat/post_message/post_message_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

void openGroup(BuildContext context, Map<String, dynamic> group) =>
    context.read<OpenGroupBloc>().add(OnOpenGroupEvent(
          group: {
            "uid": group["uid"],
            "users": group["users"],
          },
        ));

void sendMessage(
  BuildContext context,
  Map<String, dynamic> group,
  String message,
) {
  final Map<String, dynamic> user = group["users"].firstWhere(
    (Map<String, dynamic> user) => user["current"] != true,
  );

  final Map<String, dynamic> messageData = {
    "message": message,
    "recipient": user,
    "groupId": group["uid"],
  };

  info("Send message", data: messageData);

  context.read<PostMessageBloc>().add(
        OnPostMessageEvent(
          data: messageData,
        ),
      );
}
