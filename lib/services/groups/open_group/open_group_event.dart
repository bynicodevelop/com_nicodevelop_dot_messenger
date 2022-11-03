part of "open_group_bloc.dart";

abstract class OpenChatEvent extends Equatable {
  const OpenChatEvent();

  @override
  List<Object> get props => [];
}

class OnOpenGroupEvent extends OpenChatEvent {
  final Map<String, dynamic> group;

  const OnOpenGroupEvent({
    required this.group,
  });

  @override
  List<Object> get props => [
        group,
      ];
}
