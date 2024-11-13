import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/error/exceptions.dart';

class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(Uri url, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(url, headers: headers).timeout(Duration(seconds: 30));
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    }
  }

  Future<Map<String, dynamic>> post(Uri url, {Object? body, Map<String, String>? headers}) async {
    try {
      final response = await _client.post(url, headers: headers, body: body).timeout(Duration(seconds: 30));
      return _handleResponse(response);
    } on http.ClientException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body.isNotEmpty ? json.decode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody as Map<String, dynamic>;
    } else if (statusCode == 400) {
      throw ValidationException(responseBody?['message'] ?? 'Bad Request');
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException(responseBody?['message'] ?? 'Unauthorized');
    } else if (statusCode == 404) {
      throw NotFoundException(responseBody?['message'] ?? 'Not Found');
    } else if (statusCode >= 500) {
      throw ServerException(responseBody?['message'] ?? 'Server Error');
    } else {
      throw UnexpectedException('Unexpected Error');
    }
  }
}
