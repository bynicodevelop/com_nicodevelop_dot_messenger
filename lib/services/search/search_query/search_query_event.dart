part of "search_query_bloc.dart";

abstract class SearchQueryEvent extends Equatable {
  const SearchQueryEvent();

  @override
  List<Object> get props => [];
}

class OnSearchQueryEvent extends SearchQueryEvent {
  final String query;

  const OnSearchQueryEvent({
    required this.query,
  });

  @override
  List<Object> get props => [
        query,
      ];
}
