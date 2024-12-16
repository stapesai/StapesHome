// lib/features/auth/data/datasources/local/fcm_token_datasource.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stapes_home/core/error/exceptions.dart';

abstract class FCMTokenDatasource {
  Future<String?> getFCMToken();
  Stream<String> onTokenRefresh();
  Future<void> deleteToken();
}

class FCMTokenDatasourceImpl implements FCMTokenDatasource {
  final FirebaseMessaging firebaseMessaging;

  FCMTokenDatasourceImpl(this.firebaseMessaging);

  @override
  Future<String?> getFCMToken() async {
    try {
      return await firebaseMessaging.getToken();
    } catch (e) {
      throw FCMTokenException();
    }
  }

  @override
  Stream<String> onTokenRefresh() {
    return firebaseMessaging.onTokenRefresh;
  }

  @override
  Future<void> deleteToken() async {
    try {
      await firebaseMessaging.deleteToken();
    } catch (e) {
      throw FCMTokenException();
    }
  }
}
