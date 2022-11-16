part of "initialize_notification_bloc.dart";

abstract class InitializeNotificationState extends Equatable {
  const InitializeNotificationState();

  @override
  List<Object> get props => [];
}

class InitializeNotificationInitialState extends InitializeNotificationState {
  final AuthorizationStatusEnum authorizationStatusEnum;

  const InitializeNotificationInitialState({
    this.authorizationStatusEnum = AuthorizationStatusEnum.denied,
  });

  @override
  List<Object> get props => [
        authorizationStatusEnum,
      ];
}

class InitializeNotificationFailureState extends InitializeNotificationState {
  final String code;

  const InitializeNotificationFailureState({
    required this.code,
  });
}
