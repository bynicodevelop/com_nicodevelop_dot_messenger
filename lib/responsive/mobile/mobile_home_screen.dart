import "package:com_nicodevelop_dotmessenger/components/list_group_component.dart";
import "package:com_nicodevelop_dotmessenger/components/validate_account_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/components/mobile_app_bar_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/screens/mobile_chat_screen.dart";
import "package:com_nicodevelop_dotmessenger/screens/search_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  late PageController _pageController;

  int _page = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MobileAppBarComponent(
        page: _page,
        pageController: _pageController,
      ),
      body: ValidateAccountComponent(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            FocusScope.of(context).unfocus();

            setState(() => _page = value);
          },
          children: [
            BlocBuilder<ListGroupBloc, ListGroupState>(
              builder: (context, state) {
                final List<Map<String, dynamic>> groups =
                    (state as ListGroupInitialState).results;

                if (kIsWeb) {
                  return ListGroupComponent(
                    groups: groups,
                    onTap: (Map<String, dynamic> group) async {
                      openGroup(context, group);

                      _pageController.animateToPage(
                        1,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.ease,
                      );
                    },
                  );
                }

                return SafeArea(
                  child: ListGroupComponent(
                    groups: groups,
                    onTap: (Map<String, dynamic> group) async {
                      openGroup(context, group);

                      _pageController.animateToPage(
                        1,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.ease,
                      );
                    },
                  ),
                );
              },
            ),
            kIsWeb
                ? const MobileChatScreen()
                : const SafeArea(
                    child: MobileChatScreen(),
                  ),
          ],
        ),
      ),
      floatingActionButton: _page == 0
          ? FloatingActionButton(
              onPressed: () async => Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => SearchScreen(
                    onSelected: () => _pageController.animateToPage(
                      1,
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.ease,
                    ),
                  ),
                ),
              ),
              child: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
