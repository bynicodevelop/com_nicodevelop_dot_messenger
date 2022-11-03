import "package:flutter/material.dart";

class NewDiscussionButtonComponent extends StatelessWidget {
  final Function() onTap;

  const NewDiscussionButtonComponent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            80.0,
          ),
        ),
        child: Ink(
          width: 40.0,
          height: 40.0,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(
                80.0,
              ),
            ),
          ),
          child: Icon(
            Icons.edit_outlined,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
