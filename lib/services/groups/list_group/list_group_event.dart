part of "list_group_bloc.dart";

abstract class ListGroupEvent extends Equatable {
  const ListGroupEvent();

  @override
  List<Object> get props => [];
}

class OnLoadedListGroupEvent extends ListGroupEvent {
  final List<Map<String, dynamic>> groups;

  const OnLoadedListGroupEvent({
    required this.groups,
  });

  @override
  List<Object> get props => [
        groups,
      ];
}

class OnLoadListGroupEvent extends ListGroupEvent {}
