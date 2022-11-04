import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/widgets/item_group_widget.dart";
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
    if (widget.groups.isEmpty) {
      return const Center(
        child: Text("Vous n'avez pas de messages"),
      );
    }

    return ListView.builder(
      padding: ResponsiveComponent.device == DeviceEnum.mobile
          ? const EdgeInsets.only(
              top: 90,
            )
          : null,
      itemCount: widget.groups.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> group = widget.groups[index];

        final Map<String, dynamic> user =
            group["users"].firstWhere((user) => user["currentUser"] != true);

        return ItemGroupWidget(
          onTap: () => widget.onTap != null ? widget.onTap!(group) : null,
          avatarUrl: user["photoUrl"],
          displayName: user["displayName"],
          lastMessage: widget.groups[index]["lastMessage"],
          lastMessageTime: widget.groups[index]["lastMessageTime"],
          isReaded: false, // widget.groups[index]["isReaded"] ?? false,
        );
      },
    );
  }
}
