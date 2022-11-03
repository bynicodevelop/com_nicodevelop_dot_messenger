part of "list_group_bloc.dart";

abstract class ListGroupState extends Equatable {
  const ListGroupState();

  @override
  List<Object> get props => [];
}

class ListGroupInitialState extends ListGroupState {
  final bool loading;
  final List<Map<String, dynamic>> groups;

  const ListGroupInitialState({
    this.loading = true,
    this.groups = const [],
  });

  @override
  List<Object> get props => [
        groups,
        loading,
      ];
}
