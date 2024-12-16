// lib/features/auth/data/datasources/remote/fcm_token_remote_datasource.dart

import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/models/fcm_token_api_params.dart';

abstract class FCMTokenRemoteDatasource {
  Future<UpdateFCMTokenResponse> updateFCMToken(UpdateFCMTokenParams params);
}

class FCMTokenRemoteDatasourceImpl implements FCMTokenRemoteDatasource {
  final HttpClient httpClient;
  final AuthLocalDataSource authLocalDataSource;

  FCMTokenRemoteDatasourceImpl({
    required this.httpClient,
    required this.authLocalDataSource,
  });

  @override
  Future<UpdateFCMTokenResponse> updateFCMToken(UpdateFCMTokenParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.put(
        AuthRoutes.updateFCMToken,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return UpdateFCMTokenResponse.fromJson(response);
    });
  }
}
