import 'dart:io';

abstract class IApiService {
  Future<dynamic> get(String endpoint, {Map<String, String>? extraHeaders});
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders});
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders});
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders});
  Future<dynamic> delete(String endpoint, {Map<String, String>? extraHeaders});
    Future<dynamic> multipart(
    String endpoint, {
    String method = 'POST',
    Map<String, File>? files,
    Map<String,dynamic> body,
    String bodyFieldName = 'data',
    Map<String, String>? extraHeaders,
  });

}
