class SearchException implements Exception {
  final String message;
  final String code;

  const SearchException(
    this.message,
    this.code,
  );
}
