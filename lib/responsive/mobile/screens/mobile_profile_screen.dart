import "package:com_nicodevelop_dotmessenger/screens/profile_screen.dart";
import "package:flutter/material.dart";

class MobileProfileScreen extends StatelessWidget {
  const MobileProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const ProfileScreen(),
    );
  }
}
