part of "list_group_bloc.dart";

abstract class ListGroupState extends Equatable {
  const ListGroupState();

  @override
  List<Object> get props => [];
}

class ListGroupInitialState extends ListGroupState
    implements GenericLoadedState {
  final bool loading;
  @override
  final List<Map<String, dynamic>> results;

  const ListGroupInitialState({
    this.loading = true,
    this.results = const [],
  });

  @override
  List<Object> get props => [
        results,
        loading,
      ];
}
