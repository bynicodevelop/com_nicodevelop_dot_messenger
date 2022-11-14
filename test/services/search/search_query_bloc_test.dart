import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/repositories/search_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/search/search_query/search_query_bloc.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<SearchRepository>()])
import "search_query_bloc_test.mocks.dart";

void main() {
  final List<Map<String, dynamic>> resultEmpty = [];

  final List<Map<String, dynamic>> resultNoEmpty = [
    {
      "id": "1",
      "name": "test",
    },
  ];

  blocTest<SearchQueryBloc, SearchQueryState>(
    "Doit retourner une liste vide si rien n'est trouvé",
    build: () {
      final SearchRepository searchRepository = MockSearchRepository();

      // ignore: discarded_futures
      when(searchRepository.search({
        "query": "test",
      })).thenAnswer(
        (_) async => resultEmpty,
      );

      return SearchQueryBloc(
        searchRepository,
      );
    },
    act: (bloc) {
      bloc.add(const OnSearchQueryEvent(
        query: "test",
      ));
    },
    expect: () => [
      SearchQueryLoadingState(),
      SearchQuerySuccessState(
        results: resultEmpty,
      ),
    ],
  );

  blocTest(
    "Doit retourner une liste de résultats si quelque chose est trouvé",
    build: () {
      final SearchRepository searchRepository = MockSearchRepository();

      // ignore: discarded_futures
      when(searchRepository.search({
        "query": "test",
      })).thenAnswer(
        (_) async => resultNoEmpty,
      );

      return SearchQueryBloc(
        searchRepository,
      );
    },
    act: (bloc) {
      bloc.add(const OnSearchQueryEvent(
        query: "test",
      ));
    },
    expect: () => [
      SearchQueryLoadingState(),
      SearchQuerySuccessState(
        results: resultNoEmpty,
      ),
    ],
  );
}
