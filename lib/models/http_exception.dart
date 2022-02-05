class HttpExpection implements Exception {
  String message;

  HttpExpection({
    this.message,
  });

  @override
  String toString() {
    return message;
  }
}
