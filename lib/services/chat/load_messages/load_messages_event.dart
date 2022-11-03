part of "load_messages_bloc.dart";

abstract class LoadMessagesEvent extends Equatable {
  const LoadMessagesEvent();

  @override
  List<Object> get props => [];
}

class OnLoadMessagesEvent extends LoadMessagesEvent {
  final String groupId;

  const OnLoadMessagesEvent({
    required this.groupId,
  });

  @override
  List<Object> get props => [
        groupId,
      ];
}

class OnLoadedMessagesEvent extends LoadMessagesEvent {
  final List<Map<String, dynamic>> messages;

  const OnLoadedMessagesEvent({
    required this.messages,
  });

  @override
  List<Object> get props => [
        messages,
      ];
}
