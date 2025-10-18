class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic data;

  ApiException(this.statusCode, this.message, {this.data});

//ApiException: $statusCode - 

  @override
  String toString() => message;
}
