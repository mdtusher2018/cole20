class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException(this.statusCode, this.message, {this.data});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
