// ignore: depend_on_referenced_packages
import "package:bloc/bloc.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/abstract_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/notification_repository.dart";
import "package:com_nicodevelop_dotmessenger/utils/logger.dart";
import "package:equatable/equatable.dart";

part "initialize_notification_event.dart";
part "initialize_notification_state.dart";

class InitializeNotificationBloc
    extends Bloc<InitializeNotificationEvent, InitializeNotificationState> {
  final NotificationRepository notificationRepository;

  InitializeNotificationBloc(
    this.notificationRepository,
  ) : super(const InitializeNotificationInitialState()) {
    on<OnInitializeNotificationEvent>((event, emit) async {
      try {
        AuthorizationStatusEnum authorizationStatusEnum =
            await notificationRepository.initialize();

        if (authorizationStatusEnum == AuthorizationStatusEnum.authorized) {
          await notificationRepository.saveToken();
        }

        emit(
          InitializeNotificationInitialState(
            authorizationStatusEnum: authorizationStatusEnum,
          ),
        );
      } on AbstractException catch (e) {
        warn("InitializeNotificationBloc", data: {
          "code": e.code,
          "message": e.message,
        });

        emit(InitializeNotificationFailureState(
          code: e.code.toString(),
        ));
      }
    });
  }
}
