import 'dart:developer';
import 'dart:io';

import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'api_client.dart';

class ApiService implements IApiService {
  final ApiClient _client;
  final ILocalStorageService _localStorage;

  ApiService(this._client, this._localStorage);

  Future<Map<String, String>> _getHeaders({Map<String, String>? extra}) async {
    final token = await _localStorage.getString(StorageKey.token);
    log(token.toString());
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (token != null) 'SignUpToken': 'signUpToken $token',
      if (token != null) 'Forget-password': 'Forget-password $token',
      if (extra != null) ...extra,
    };
    return headers;
  }

  @override
  Future<dynamic> get(String endpoint, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.get(url, headers: headers);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.post(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.put(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.patch(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> delete(String endpoint, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.delete(url, headers: headers);
  }



 @override
  Future<dynamic> multipart(
    String endpoint, {
    String method = 'POST',
    Map<String, File>? files,
    dynamic body,
    String bodyFieldName = 'data', // field name for JSON body
    Map<String, String>? extraHeaders,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.sendMultipart(
      url,
      method: method,
      headers: headers,
      files: files,
      body: body,
      bodyFieldName: bodyFieldName,
    );
  }






}
