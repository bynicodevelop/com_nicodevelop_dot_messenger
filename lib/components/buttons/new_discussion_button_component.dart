import "package:com_nicodevelop_dotmessenger/components/buttons/generic_icon_button_component.dart";
import "package:flutter/material.dart";

class NewDiscussionButtonComponent extends StatelessWidget {
  final Function() onTap;

  const NewDiscussionButtonComponent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GenericIconButtonComponent(
      icon: Icons.edit_outlined,
      onTap: onTap,
    );
  }
}
