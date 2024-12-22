// ...existing code...
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/models/user_session_model.dart';

abstract class SessionsRemoteDataSource {
  Future<List<UserSessionModel>> getAllSessions(String userId, String currentSessionId);
  Future<void> revokeSession(String userId, String sessionId);
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  final http.Client client;
  final String baseUrl; // e.g. your FastAPI sessions endpoint

  SessionsRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<UserSessionModel>> getAllSessions(String userId, String currentSessionId) async {
    final uri = Uri.parse('$baseUrl/all');
    final body = {"user_id": userId, "session_id": currentSessionId};
    final response = await client.post(uri, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Error fetching sessions');
    }
    final data = jsonDecode(response.body);
    final sessionsJson = data['sessions'] as List;
    return sessionsJson
        .map((item) => UserSessionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> revokeSession(String userId, String sessionId) async {
    final uri = Uri.parse('$baseUrl/revoke');
    final body = {"user_id": userId, "session_id": sessionId};
    final response = await client.post(uri, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Error revoking session');
    }
  }
}