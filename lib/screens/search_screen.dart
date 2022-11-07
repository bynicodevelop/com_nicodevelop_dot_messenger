import "dart:async";

import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/services/search/search_query/search_query_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/helpers.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:com_nicodevelop_dotmessenger/widgets/avatar_widget.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";
import "package:validators/sanitizers.dart";

class SearchScreen extends StatefulWidget {
  final Function()? onSelected;

  const SearchScreen({
    Key? key,
    this.onSelected,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<SearchQueryBloc>().add(
          const OnSearchQueryEvent(
            query: "",
          ),
        );

    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty ||
          _searchController.text.length > 3) {
        _sendQuery(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _sendQuery(String query) {
    debounce(
      () => context.read<SearchQueryBloc>().add(
            OnSearchQueryEvent(
              query: query,
            ),
          ),
      500,
    );
  }

  void debounce(void Function() cb, int delay) {
    Timer? timer;

    if (timer != null) {
      timer.cancel();
    }

    timer = Timer(
      Duration(
        milliseconds: delay,
      ),
      cb,
    );
  }

  double _responsiveWidth(BuildContext context) {
    if (ResponsiveComponent.device == DeviceEnum.desktop) {
      return MediaQuery.of(context).size.width * 0.35;
    }

    if (ResponsiveComponent.device == DeviceEnum.tablet) {
      return MediaQuery.of(context).size.width * 0.25;
    }

    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20.0,
          left: _responsiveWidth(context),
          right: _responsiveWidth(context),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();

                      _sendQuery(_searchController.text);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocBuilder<SearchQueryBloc, SearchQueryState>(
                  builder: (context, state) {
                if (state is SearchQueryLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchQuerySuccessState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.result.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () async {
                            Map<String, dynamic> openDiscussion = {
                              "users": [
                                {
                                  "uid": state.result[index]["uid"],
                                  "displayName": state.result[index]
                                      ["displayName"],
                                  "photoURL": state.result[index]["photoURL"],
                                }
                              ],
                            };

                            if (state.result[index]["groupId"] != null &&
                                trim(state.result[index]["groupId"]) != "") {
                              openDiscussion["uid"] =
                                  state.result[index]["groupId"];
                            }

                            info(
                              "Open discussion with user",
                              data: openDiscussion,
                            );

                            openGroup(context, openDiscussion);

                            Navigator.pop(context);

                            widget.onSelected?.call();
                          },
                          title: Text(state.result[index]["displayName"]),
                          leading: AvatarWidget(
                            avatarUrl: state.result[index]["photoUrl"],
                            username: state.result[index]["displayName"],
                          ),
                          trailing: const Icon(
                            Icons.message_rounded,
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
