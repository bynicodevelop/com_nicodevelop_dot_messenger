import "package:com_nicodevelop_dotmessenger/components/bottom_side_menu_component.dart";
import "package:flutter/material.dart";

class LeftColumnConstrainedBoxComponent extends StatelessWidget {
  final Widget child;
  final double minWidth;

  const LeftColumnConstrainedBoxComponent({
    super.key,
    required this.child,
    this.minWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (MediaQuery.of(context).size.width * 0.25) >= minWidth
            ? MediaQuery.of(context).size.width * 0.25
            : minWidth + 1,
      ),
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          const BottomSideMenuComponent(),
        ],
      ),
    );
  }
}
