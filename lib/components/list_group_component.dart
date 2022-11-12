import "package:com_nicodevelop_dotmessenger/components/empty_wrapper_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:com_nicodevelop_dotmessenger/widgets/item_group_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class ListGroupComponent extends StatefulWidget {
  final List<Map<String, dynamic>> groups;

  final Function()? onInit;
  final Function(Map<String, dynamic> group)? onTap;

  const ListGroupComponent({
    super.key,
    required this.groups,
    this.onInit,
    this.onTap,
  });

  @override
  State<ListGroupComponent> createState() => _ListGroupComponentState();
}

class _ListGroupComponentState extends State<ListGroupComponent> {
  @override
  void initState() {
    super.initState();

    if (widget.onInit != null) {
      widget.onInit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EmptyWrapperComponent<ListGroupBloc, ListGroupState>(
      message: "Aucun groupe",
      child: ListView.builder(
        padding: ResponsiveComponent.device == DeviceEnum.mobile
            ? const EdgeInsets.only(
                top: kIsWeb ? 90 : 5,
              )
            : null,
        itemCount: widget.groups.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> group = widget.groups[index];

          final Map<String, dynamic> user = excludeCurrentUser(
            group["users"],
          );

          return ItemGroupWidget(
            onTap: () => widget.onTap != null ? widget.onTap!(group) : null,
            avatarUrl: user["photoUrl"],
            displayName: user["displayName"],
            lastMessage: widget.groups[index]["lastMessage"],
            lastMessageTime: widget.groups[index]["lastMessageTime"],
            isReaded: false, // widget.groups[index]["isReaded"] ?? false,
          );
        },
      ),
    );
  }
}
