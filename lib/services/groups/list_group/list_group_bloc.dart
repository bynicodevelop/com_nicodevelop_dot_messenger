// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:equatable/equatable.dart";

part "list_group_event.dart";
part "list_group_state.dart";

class ListGroupBloc extends Bloc<ListGroupEvent, ListGroupState> {
  late GroupRepository groupRepository;

  ListGroupBloc(this.groupRepository) : super(const ListGroupInitialState()) {
    groupRepository.groups.listen((List<Map<String, dynamic>> groups) {
      add(OnLoadedListGroupEvent(groups: groups));
    });

    on<OnLoadedListGroupEvent>((event, emit) async {
      emit(ListGroupInitialState(
        loading: false,
        groups: event.groups,
      ));
    });

    on<OnLoadListGroupEvent>((event, emit) async {
      emit(ListGroupInitialState(
        loading: true,
        groups: (state as ListGroupInitialState).groups,
      ));

      await groupRepository.load();
    });
  }
}
