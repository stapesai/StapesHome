// File: lib/core/network/http_client.dart
// Description: This file contains a custom HTTP client for making network requests with error handling and retries.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/config/config.dart';
import 'package:stapes_home/core/error/exceptions.dart';

/// A custom HTTP client for making network requests with error handling and retries
class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  /// Sends a GET request to the specified URL
  ///
  /// Parameters:
  /// - url: The URL to send the request to
  /// - headers: Optional headers to include in the request
  ///
  /// Returns:
  /// A Future that resolves to the response body as a Map<String, dynamic>
  Future<Map<String, dynamic>> get(Uri url, {Map<String, String>? headers}) async {
    return _sendRequest(() => _client.get(url, headers: headers));
  }

  /// Sends a POST request to the specified URL
  ///
  /// Parameters:
  /// - url: The URL to send the request to
  /// - body: The body of the POST request
  /// - headers: Optional headers to include in the request
  ///
  /// Returns:
  /// A Future that resolves to the response body as a Map<String, dynamic>
  Future<Map<String, dynamic>> post(Uri url, {Object? body, Map<String, String>? headers}) async {
    return _sendRequest(() => _client.post(url, body: body, headers: headers));
  }

  /// Sends a PUT request to the specified URL
  ///
  /// Parameters:
  /// - url: The URL to send the request to
  /// - body: The body of the PUT request
  /// - headers: Optional headers to include in the request
  ///
  /// Returns:
  /// A Future that resolves to the response body as a Map<String, dynamic>
  Future<Map<String, dynamic>> put(Uri url, {Object? body, Map<String, String>? headers}) async {
    return _sendRequest(() => _client.put(url, body: body, headers: headers));
  }

  /// Sends a DELETE request to the specified URL
  ///
  /// Parameters:
  /// - url: The URL to send the request to
  /// - headers: Optional headers to include in the request
  ///
  /// Returns:
  /// A Future that re   solves to the response body as a Map<String, dynamic>
  Future<Map<String, dynamic>> delete(Uri url, {Map<String, String>? headers}) async {
    return _sendRequest(() => _client.delete(url, headers: headers));
  }

  /// Helper method to send requests with retry logic and error handling
  Future<Map<String, dynamic>> _sendRequest(Future<http.Response> Function() request) async {
    int retries = 0;

    // TODO: log the request details
    // Create the request (now we capture the request separately for logging)
    // final http.Request httpRequest = request() as http.Request;

    // Log the request details
    // logRequest(httpRequest);

    while (retries < Config.maxRetryAttempts) {
      try {
        final response = await request().timeout(Duration(seconds: Config.networkTimeoutSeconds));
        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Log the response details
        logResponse(response);

        // TODO: Don't use range in status code, use explicit checks according to the type
        // of request (GET (200), POST(201), PUT, DELETE). Reffer backend API documentation
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return responseBody;
        } else if (response.statusCode == 401) {
          throw UnauthorizedException(responseBody['detail']);
        } else if (response.statusCode == 404) {
          throw NotFoundException();
        } else {
          throw ServerException('HTTP ${response.statusCode}: ${response.reasonPhrase}');
        }
      } on TimeoutException {
        retries++;
        if (retries >= Config.maxRetryAttempts) {
          throw TimeoutException('Request timed out after ${Config.networkTimeoutSeconds} seconds');
        }
      } catch (e) {
        if (e is UnauthorizedException || e is NotFoundException) {
          rethrow;
        }
        retries++;
        if (retries >= Config.maxRetryAttempts) {
          throw ServerException('Failed after $retries attempts: $e');
        }
      }

      // Wait before retrying
      await Future.delayed(Duration(milliseconds: Config.retryDelayMilliseconds << retries));
    }

    throw ServerException('Unexpected error occurred');
  }

  /// Closes the HTTP client
  void close() {
    _client.close();
  }
}

/// Extension on HttpClient to add logging functionality
extension HttpClientLogging on HttpClient {
  /// Logs the details of an HTTP request
  void logRequest(http.Request request) {
    if (Config.enableDetailedLogs) {
      print('------------------------------');
      print('HTTP Request:');
      print('URL: ${request.url}');
      print('Method: ${request.method}');
      if (request.headers.isNotEmpty) print('Headers: ${request.headers}');
      if (request.body.isNotEmpty) print('Body: ${request.body}');
      print('------------------------------');
    }
  }

  /// Logs the details of an HTTP response
  void logResponse(http.Response response) {
    if (Config.enableDetailedLogs) {
      print('------------------------------');
      print('HTTP Response:');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('------------------------------');
    }
  }
}
