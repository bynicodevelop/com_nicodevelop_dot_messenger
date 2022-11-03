import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("OpenGroupBloc", () {
    late OpenGroupBloc openGroupBloc;
    late Map<String, dynamic> group;

    setUp(() {
      openGroupBloc = OpenGroupBloc();
    });

    blocTest(
      "Doit retourner un group",
      build: () {
        group = {
          "uid": "uid",
          "displayName": "displayName",
          "photoUrl": "photoUrl",
        };

        return openGroupBloc;
      },
      act: (bloc) => bloc.add(OnOpenGroupEvent(
        group: group,
      )),
      expect: () => [
        OpenChatInitialState(
          group: group,
        )
      ],
    );
  });
}
