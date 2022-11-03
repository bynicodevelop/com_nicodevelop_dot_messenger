part of "load_messages_bloc.dart";

abstract class LoadMessagesState extends Equatable {
  const LoadMessagesState();

  @override
  List<Object> get props => [];
}

class LoadMessagesInitialState extends LoadMessagesState {
  final bool loading;
  final List<Map<String, dynamic>> messages;

  const LoadMessagesInitialState({
    this.loading = true,
    this.messages = const [],
  });

  @override
  List<Object> get props => [
        loading,
        messages,
      ];
}
