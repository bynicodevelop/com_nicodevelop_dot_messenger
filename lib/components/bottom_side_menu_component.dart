import "package:com_nicodevelop_dotmessenger/components/buttons/new_discussion_button_component.dart";
import "package:com_nicodevelop_dotmessenger/components/buttons/settings_button_component.dart";
import "package:com_nicodevelop_dotmessenger/screens/profile_screen.dart";
import "package:com_nicodevelop_dotmessenger/screens/search_screen.dart";
import "package:flutter/material.dart";

class BottomSideMenuComponent extends StatelessWidget {
  const BottomSideMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          NewDiscussionButtonComponent(
            onTap: () async => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            ),
          ),
          SettingsButtonComponent(
            onTap: () async => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
