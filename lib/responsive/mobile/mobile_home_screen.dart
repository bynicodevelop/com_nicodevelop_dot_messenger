import "package:com_nicodevelop_dotmessenger/components/list_group_component.dart";
import "package:com_nicodevelop_dotmessenger/components/validate_account_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/components/mobile_app_bar_component.dart";
import "package:com_nicodevelop_dotmessenger/responsive/mobile/screens/mobile_chat_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import 'package:com_nicodevelop_dotmessenger/utils/helpers.dart';
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
          onPageChanged: (value) => setState(() => _page = value),
          children: [
            BlocBuilder<ListGroupBloc, ListGroupState>(
              builder: (context, state) {
                final List<Map<String, dynamic>> groups =
                    (state as ListGroupInitialState).groups;

                if (groups.isEmpty) {
                  return const Center(
                    child: Text("Aucune discussion"),
                  );
                }

                return ListGroupComponent(
                  groups: groups,
                  onTap: (Map<String, dynamic> group) async {
                    context.read<OpenGroupBloc>().add(OnOpenGroupEvent(
                          group: {
                            "uid": group["uid"],
                            "displayName": group["displayName"],
                            "photoUrl": group["photoUrl"],
                          },
                        ));

                    _pageController.animateToPage(
                      1,
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.ease,
                    );
                  },
                );
              },
            ),
            const MobileChatScreen(),
          ],
        ),
      ),
    );
  }
}
