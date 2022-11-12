import "package:com_nicodevelop_dotmessenger/components/empty_wrapper_component.dart";
import "package:com_nicodevelop_dotmessenger/repositories/search_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/search/search_query/search_query_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<SearchRepository>()])
import "empty_wrapper_component_test.mocks.dart";

void main() {
  testWidgets("EmptyWrapperComponent has message", (WidgetTester tester) async {
    // ARRANGE
    final SearchRepository searchRepository = MockSearchRepository();

    when(searchRepository.search({
      "query": "",
    })).thenAnswer((_) async => []);

    final SearchQueryBloc searchQueryBloc = SearchQueryBloc(
      searchRepository,
    )..add(
        const OnSearchQueryEvent(
          query: "",
        ),
      );

    await tester.pumpWidget(
      BlocProvider<SearchQueryBloc>(
        create: (context) => searchQueryBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: EmptyWrapperComponent<SearchQueryBloc, SearchQueryState>(
              child: Text("Hello World"),
            ),
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text("No data found"), findsOneWidget);
  });

  testWidgets("EmptyWrapperComponent show child", (WidgetTester tester) async {
    // ARRANGE
    final SearchRepository searchRepository = MockSearchRepository();

    when(searchRepository.search({
      "query": "john",
    })).thenAnswer((_) async => [
          {
            "id": 1,
            "name": "John Doe",
            "avatar": "https://example.com/avatar.png",
          },
        ]);

    final SearchQueryBloc searchQueryBloc = SearchQueryBloc(
      searchRepository,
    )..add(
        const OnSearchQueryEvent(
          query: "john",
        ),
      );

    await tester.pumpWidget(
      BlocProvider<SearchQueryBloc>(
        create: (context) => searchQueryBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: EmptyWrapperComponent<SearchQueryBloc, SearchQueryState>(
              message: "Vous n'avez pas de messages",
              child: Text("Hello World"),
            ),
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text("Hello World"), findsOneWidget);
    expect(find.text("Vous n'avez pas de messages"), findsNothing);
  });

  testWidgets("EmptyWrapperComponent has custom message",
      (WidgetTester tester) async {
    // ARRANGE
    final SearchRepository searchRepository = MockSearchRepository();

    when(searchRepository.search({
      "query": "",
    })).thenAnswer((_) async => []);

    final SearchQueryBloc searchQueryBloc = SearchQueryBloc(
      searchRepository,
    )..add(
        const OnSearchQueryEvent(
          query: "",
        ),
      );

    await tester.pumpWidget(
      BlocProvider<SearchQueryBloc>(
        create: (context) => searchQueryBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: EmptyWrapperComponent<SearchQueryBloc, SearchQueryState>(
              message: "Vous n'avez pas de messages",
              child: Text("Hello World"),
            ),
          ),
        ),
      ),
    );

    // ACT
    // ASSERT
    expect(find.text("Custom child"), findsNothing);
    expect(find.text("Vous n'avez pas de messages"), findsOneWidget);
  });
}
