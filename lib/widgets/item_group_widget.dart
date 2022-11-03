import "package:com_nicodevelop_dotmessenger/widgets/avatar_widget.dart";
import "package:flutter/material.dart";

class ItemGroupWidget extends StatelessWidget {
  final String avatarUrl;
  final String displayName;
  final String lastMessage;
  final String lastMessageTime;
  final bool isReaded;

  final Function()? onTap;

  const ItemGroupWidget({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.isReaded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AvatarWidget(
        avatarUrl: avatarUrl,
      ),
      title: Text(
        displayName,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: isReaded ? FontWeight.normal : FontWeight.bold,
            ),
      ),
      subtitle: Text(
        lastMessage,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: isReaded ? FontWeight.normal : FontWeight.bold,
            ),
      ),
      trailing: Text(
        lastMessageTime,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontWeight: isReaded ? FontWeight.normal : FontWeight.bold,
            ),
      ),
    );
  }
}
