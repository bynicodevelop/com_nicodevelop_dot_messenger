import "package:flutter/material.dart";

class AvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? username;

  const AvatarWidget({
    super.key,
    this.avatarUrl,
    this.username,
  });

  String _getInial() {
    if (username == null) {
      return "";
    }

    final List<String> parts = username!.split(" ");

    return parts.map((e) => e.substring(0, 1)).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: avatarUrl == null || avatarUrl!.isEmpty
          ? null
          : NetworkImage(avatarUrl!),
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? Text(
              username != null ? _getInial() : "",
            )
          : null,
    );
  }
}
