import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

void openGroup(BuildContext context, Map<String, dynamic> group) =>
    context.read<OpenGroupBloc>().add(OnOpenGroupEvent(
          group: {
            "uid": group["uid"],
            "users": group["users"],
          },
        ));
