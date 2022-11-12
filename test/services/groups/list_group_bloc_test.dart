import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<GroupRepository>()])
import "list_group_bloc_test.mocks.dart";

void main() {
  group("OnLoadListGroupEvent", () {
    late GroupRepository groupRepository;

    setUp(() {
      groupRepository = MockGroupRepository();
    });

    blocTest<ListGroupBloc, ListGroupState>(
      "Doit permettre le chargement d'une liste de groupes",
      build: () {
        return ListGroupBloc(
          groupRepository,
        );
      },
      act: (ListGroupBloc bloc) => bloc.add(OnLoadListGroupEvent()),
      expect: () => [
        const ListGroupInitialState(
          loading: true,
          results: [],
        ),
      ],
      verify: (bloc) async => verify(groupRepository.load()).called(1),
    );
  });

  group("OnLoadedListGroupEvent", () {
    late GroupRepository groupRepository;

    setUp(() {
      groupRepository = MockGroupRepository();
    });

    blocTest<ListGroupBloc, ListGroupState>(
      "Doit retourner une liste vide",
      build: () {
        return ListGroupBloc(
          groupRepository,
        );
      },
      act: (ListGroupBloc bloc) => bloc.add(const OnLoadedListGroupEvent(
        groups: [],
      )),
      expect: () => [
        const ListGroupInitialState(
          loading: false,
          results: [],
        ),
      ],
    );

    blocTest<ListGroupBloc, ListGroupState>(
      "Doit retourner une liste avec au moins un élément",
      build: () {
        return ListGroupBloc(
          groupRepository,
        );
      },
      act: (ListGroupBloc bloc) => bloc.add(const OnLoadedListGroupEvent(
        groups: [
          {
            "uid": "uid",
            "photoUrl": "https://placekitten.com/250/250?img=1",
            "lastMessage": "Hey, how are you?",
            "lastMessageTime": "12:30",
            "displayName": "John Doe",
            "isReaded": true,
          },
        ],
      )),
      expect: () => [
        const ListGroupInitialState(
          loading: false,
          results: [
            {
              "uid": "uid",
              "photoUrl": "https://placekitten.com/250/250?img=1",
              "lastMessage": "Hey, how are you?",
              "lastMessageTime": "12:30",
              "displayName": "John Doe",
              "isReaded": true,
            },
          ],
        ),
      ],
    );
  });
}
