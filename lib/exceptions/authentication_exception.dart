class AuthenticationException implements Exception {
  final String message;
  final String code;

  const AuthenticationException(
    this.message,
    this.code,
  );
}
