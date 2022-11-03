part of "search_query_bloc.dart";

abstract class SearchQueryState extends Equatable {
  const SearchQueryState();

  @override
  List<Object> get props => [];
}

class SearchQueryInitialState extends SearchQueryState {}

class SearchQueryLoadingState extends SearchQueryState {}

class SearchQuerySuccessState extends SearchQueryState {
  final List<Map<String, dynamic>> result;

  const SearchQuerySuccessState({
    required this.result,
  });

  @override
  List<Object> get props => [
        result,
      ];
}

class SearchQueryFailureState extends SearchQueryState {
  final String code;

  const SearchQueryFailureState({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}
