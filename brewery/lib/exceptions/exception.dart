class ValidateException implements Exception {
  final String message;

  const ValidateException(this.message);

  String toString() => this.message;
}

class InvalidBeerStatusException extends ValidateException {
  InvalidBeerStatusException(String message) : super(message);
}
