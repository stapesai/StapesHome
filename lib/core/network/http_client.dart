import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/error/exceptions.dart';

class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on http.ClientException {
      throw NetworkException('Network error occurred');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException {
      throw UnexpectedException('Invalid response format');
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  Future<Map<String, dynamic>> get(Uri url, {Map<String, String>? headers}) async {
    final response = await _client.get(url, headers: headers).timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(Uri url, {Object? body, Map<String, String>? headers}) async {
    final response = await _client.post(url, headers: headers, body: body).timeout(const Duration(seconds: 30));
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body.isNotEmpty ? json.decode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody as Map<String, dynamic>;
    } else if (statusCode == 400) {
      throw ValidationException(responseBody?['detail'] ?? 'Bad Request');
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException(responseBody?['detail'] ?? 'Unauthorized');
    } else if (statusCode == 404) {
      throw NotFoundException(responseBody?['detail'] ?? 'Not Found');
    } else if (statusCode == 422) {
      // throw ValidationException(responseBody?['detail'] ?? 'Validation Error');
      // TODO: show error from server. but server returns validation error in differnt format.
      throw ValidationException('Validation Error. You Entered Something Wrong.');
    } else if (statusCode >= 500 && statusCode < 600) {
      throw ServerException(responseBody?['detail'] ?? 'Server Error');
    } else {
      throw UnexpectedException('Unexpected Error');
    }
  }
}
