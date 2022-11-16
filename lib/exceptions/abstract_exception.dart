abstract class AbstractException implements Exception {
  final String message;
  final String code;

  const AbstractException(
    this.message,
    this.code,
  );
}
