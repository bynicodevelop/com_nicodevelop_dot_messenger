class ChatException implements Exception {
  final String message;
  final String code;

  const ChatException(
    this.message,
    this.code,
  );
}
