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
        return ItemGroupWidget(
          onTap: () =>
              widget.onTap != null ? widget.onTap!(widget.groups[index]) : null,
          avatarUrl: widget.groups[index]["avatarUrl"],
          displayName: widget.groups[index]["displayName"],
          lastMessage: widget.groups[index]["lastMessage"],
          lastMessageTime: widget.groups[index]["lastMessageTime"],
          isReaded: widget.groups[index]["isReaded"],
        );
      },
    );
  }
}
