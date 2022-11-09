// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/search_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/search_repository.dart";
import "package:equatable/equatable.dart";

part "search_query_event.dart";
part "search_query_state.dart";

class SearchQueryBloc extends Bloc<SearchQueryEvent, SearchQueryState> {
  final SearchRepository searchRepository;

  SearchQueryBloc(
    this.searchRepository,
  ) : super(SearchQueryInitialState()) {
    on<OnSearchQueryEvent>((event, emit) async {
      emit(SearchQueryLoadingState());

      try {
        final List<Map<String, dynamic>> result =
            await searchRepository.search({
          "query": event.query,
        });

        emit(SearchQuerySuccessState(
          result: result,
        ));
      } on SearchException catch (e) {
        emit(SearchQueryFailureState(
          code: e.code,
        ));
      }
    });
  }
}
