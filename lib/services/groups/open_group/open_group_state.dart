part of "open_group_bloc.dart";

abstract class OpenGroupState extends Equatable {
  const OpenGroupState();

  @override
  List<Object> get props => [];
}

class OpenChatInitialState extends OpenGroupState {
  final Map<String, dynamic> group;

  const OpenChatInitialState({
    this.group = const {},
  });

  @override
  List<Object> get props => [
        group,
      ];
}
