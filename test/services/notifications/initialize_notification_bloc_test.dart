import "package:bloc_test/bloc_test.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/authentication_exception.dart";
import "package:com_nicodevelop_dotmessenger/exceptions/notification_exception.dart";
import "package:com_nicodevelop_dotmessenger/repositories/notification_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/notifications/initialize_notification/initialize_notification_bloc.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<NotificationRepository>()])
import "initialize_notification_bloc_test.mocks.dart";

void main() {
  late NotificationRepository notificationRepository;

  setUp(() {
    notificationRepository = MockNotificationRepository();
  });

  blocTest<InitializeNotificationBloc, InitializeNotificationState>(
    "Doit enregistrer le token de notification",
    build: () {
      when(notificationRepository.initialize()).thenAnswer(
        (_) async => AuthorizationStatusEnum.authorized,
      );

      return InitializeNotificationBloc(notificationRepository);
    },
    act: (bloc) {
      bloc.add(OnInitializeNotificationEvent());
    },
    expect: () {
      return [
        const InitializeNotificationInitialState(
          authorizationStatusEnum: AuthorizationStatusEnum.authorized,
        ),
      ];
    },
    verify: (_) {
      verify(notificationRepository.saveToken()).called(1);
    },
  );

  blocTest<InitializeNotificationBloc, InitializeNotificationState>(
    "Ne doit pas enregistrer le token de notification (notification denied)",
    build: () {
      when(notificationRepository.initialize()).thenAnswer(
        (_) async => AuthorizationStatusEnum.denied,
      );

      return InitializeNotificationBloc(notificationRepository);
    },
    act: (bloc) {
      bloc.add(OnInitializeNotificationEvent());
    },
    expect: () {
      return [
        const InitializeNotificationInitialState(
          authorizationStatusEnum: AuthorizationStatusEnum.denied,
        ),
      ];
    },
    verify: (_) {
      verifyNever(notificationRepository.saveToken());
    },
  );

  blocTest<InitializeNotificationBloc, InitializeNotificationState>(
    "Ne doit pas enregistrer le token de notification (notification provisional)",
    build: () {
      when(notificationRepository.initialize()).thenAnswer(
        (_) async => AuthorizationStatusEnum.provisional,
      );

      return InitializeNotificationBloc(notificationRepository);
    },
    act: (bloc) {
      bloc.add(OnInitializeNotificationEvent());
    },
    expect: () {
      return [
        const InitializeNotificationInitialState(
          authorizationStatusEnum: AuthorizationStatusEnum.provisional,
        ),
      ];
    },
    verify: (_) {
      verifyNever(notificationRepository.saveToken());
    },
  );

  blocTest<InitializeNotificationBloc, InitializeNotificationState>(
    "Doit retourner une erreur quand une exception est levée (NotificationException)",
    build: () {
      when(notificationRepository.initialize()).thenThrow(
        const NotificationException(
          "Une erreur est survenue",
          "invalid_token",
        ),
      );

      return InitializeNotificationBloc(notificationRepository);
    },
    act: (bloc) {
      bloc.add(OnInitializeNotificationEvent());
    },
    expect: () {
      return [
        const InitializeNotificationFailureState(
          code: "invalid_token",
        ),
      ];
    },
    verify: (_) {
      verifyNever(notificationRepository.saveToken());
    },
  );

  blocTest<InitializeNotificationBloc, InitializeNotificationState>(
    "Doit retourner une erreur quand une exception est levée (AuthenticationException)",
    build: () {
      when(notificationRepository.initialize()).thenThrow(
        const AuthenticationException(
          "Une erreur est survenue",
          "unauthenticated",
        ),
      );

      return InitializeNotificationBloc(notificationRepository);
    },
    act: (bloc) {
      bloc.add(OnInitializeNotificationEvent());
    },
    expect: () {
      return [
        const InitializeNotificationFailureState(
          code: "unauthenticated",
        ),
      ];
    },
    verify: (_) {
      verifyNever(notificationRepository.saveToken());
    },
  );
}
