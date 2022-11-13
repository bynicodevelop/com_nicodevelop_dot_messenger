part of "load_messages_bloc.dart";

abstract class LoadMessagesState extends Equatable {
  const LoadMessagesState();

  @override
  List<Object> get props => [];
}

class LoadMessagesInitialState extends LoadMessagesState
    implements GenericLoadedState {
  final bool loading;

  @override
  final List<Map<String, dynamic>> results;

  const LoadMessagesInitialState({
    this.loading = true,
    this.results = const [],
  });

  @override
  List<Object> get props => [
        loading,
        results,
      ];
}
