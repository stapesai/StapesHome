import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/models/user_session_model.dart';

abstract class SessionsRemoteDataSource {
  Future<List<UserSessionModel>> getAllSessions(String userId, String sessionId);
  Future<void> revokeSession(String userId, String sessionId);
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  SessionsRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<UserSessionModel>> getAllSessions(String userId, String sessionId) async {
    final uri = Uri.parse('$baseUrl/all');
    final body = {
      "user_id": userId,
      "session_id": sessionId,
      "device_name": "",
      "device_type": "Android",
      "device_manufacturer": "",
      "device_model": "",
      "device_system_version": "",
    };
    final response = await client.post(uri, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Error fetching sessions');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sessions = data['sessions'] as List?;
    if (sessions == null) return [];
    return sessions.map((js) => UserSessionModel.fromJson(js)).toList();
  }

  @override
  Future<void> revokeSession(String userId, String sessionId) async {
    final uri = Uri.parse('$baseUrl/revoke');
    final body = {
      "user_id": userId,
      "session_id": sessionId,
    };
    final response = await client.post(uri, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception('Error revoking session');
    }
  }
}
