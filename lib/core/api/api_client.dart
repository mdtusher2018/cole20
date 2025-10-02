import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<dynamic> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _httpClient.get(url, headers: headers);
    return _processResponse(response);
  }

  Future<dynamic> post(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final response = await _httpClient.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> put(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final response = await _httpClient.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> patch(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final response = await _httpClient.patch(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(Uri url, {Map<String, String>? headers}) async {
    final response = await _httpClient.delete(url, headers: headers);
    return _processResponse(response);
  }

Future<dynamic> sendMultipart(
  Uri url, {
  String method = 'POST',
  Map<String, String>? headers,
  Map<String, File>? files,
  dynamic body,
  String bodyFieldName = 'data', // default field name for JSON body
}) async {
  final request = http.MultipartRequest(method.toUpperCase(), url);

  if (headers != null) {
    request.headers.addAll(headers);
  }

  if (files != null) {
    files.forEach((fieldName, file) {
      final multipartFile = http.MultipartFile.fromBytes(
        fieldName,
        file.readAsBytesSync(),
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);
    });
  }

  // Add JSON body as a single field
  if (body != null) {
    request.fields[bodyFieldName] = jsonEncode(body);
  }

  // Send request
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);

  return _processResponse(response);
}



  dynamic _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
log(response.body);
    if (statusCode >= 200 && statusCode < 300) return body;

    throw ApiException(statusCode, body?['message'] ?? 'Unknown error', data: body);
  }
}
