part of "post_message_bloc.dart";

abstract class PostMessageState extends Equatable {
  const PostMessageState();

  @override
  List<Object> get props => [];
}

class PostMessageInitialState extends PostMessageState {}

class PostMessageLoadingState extends PostMessageState {}

class PostMessageSuccessState extends PostMessageState {}

class NewGroupCreatedState extends PostMessageState {
  final String groupId;

  const NewGroupCreatedState({
    required this.groupId,
  });

  @override
  List<Object> get props => [
        groupId,
      ];
}

class PostMessageFailureState extends PostMessageState {
  final String code;

  const PostMessageFailureState({
    required this.code,
  });

  @override
  List<Object> get props => [
        code,
      ];
}
