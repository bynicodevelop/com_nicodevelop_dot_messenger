class UpdateProfileException implements Exception {
  final String message;
  final String code;

  const UpdateProfileException(
    this.message,
    this.code,
  );
}
