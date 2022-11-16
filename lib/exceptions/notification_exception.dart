import "package:com_nicodevelop_dotmessenger/exceptions/abstract_exception.dart";

class NotificationException implements AbstractException {
  @override
  final String message;
  @override
  final String code;

  const NotificationException(
    this.message,
    this.code,
  );
}
