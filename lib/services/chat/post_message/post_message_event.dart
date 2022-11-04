part of "post_message_bloc.dart";

abstract class PostMessageEvent extends Equatable {
  const PostMessageEvent();

  @override
  List<Object> get props => [];
}

class OnPostMessageEvent extends PostMessageEvent {
  final Map<String, dynamic> data;

  const OnPostMessageEvent({
    required this.data,
  });

  @override
  List<Object> get props => [
        data,
      ];
}
