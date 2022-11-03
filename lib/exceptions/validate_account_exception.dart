class ValidateAccountException implements Exception {
  final String message;
  final String code;

  const ValidateAccountException(
    this.message,
    this.code,
  );
}
