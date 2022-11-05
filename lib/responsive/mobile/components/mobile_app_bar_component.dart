import "package:com_nicodevelop_dotmessenger/components/buttons/settings_button_component.dart";
import "package:com_nicodevelop_dotmessenger/components/chat_heading_bar_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/screens/mobile_profile_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/widgets/blurry_heading_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MobileAppBarComponent extends StatelessWidget
    implements PreferredSizeWidget {
  final int page;
  final PageController pageController;

  const MobileAppBarComponent({
    super.key,
    required this.page,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlurryHeadingWidget(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: page == 0
            ? Stack(
                children: [
                  const Positioned(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Messages",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SettingsButtonComponent(
                        onTap: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileProfileScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : BlocBuilder<OpenGroupBloc, OpenGroupState>(
                builder: (context, state) {
                  final Map<String, dynamic> group =
                      (state as OpenChatInitialState).group;

                  Map<String, dynamic> user = group["users"].firstWhere(
                    (Map<String, dynamic> user) => user["uid"] != true,
                  );

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 15,
                        child: ClipOval(
                          child: Material(
                            type: MaterialType.transparency,
                            child: InkWell(
                              onTap: () async {
                                pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: const SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: ChatHeadingBarComponent(
                          profile: {
                            "displayName": user["displayName"],
                            "photoUrl": user["photoUrl"],
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
