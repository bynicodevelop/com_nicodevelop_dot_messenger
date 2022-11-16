part of "initialize_notification_bloc.dart";

abstract class InitializeNotificationEvent extends Equatable {
  const InitializeNotificationEvent();

  @override
  List<Object> get props => [];
}

class OnInitializeNotificationEvent extends InitializeNotificationEvent {}
