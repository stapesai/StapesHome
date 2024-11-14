import 'package:flutter_regex/flutter_regex.dart';
import 'package:auth/data/datasources/remote/auth_remote_datasource.dart';

class EmailValidator {
  final AuthRemoteDataSource _authRemoteDataSource;

  EmailValidator(this._authRemoteDataSource);

  bool isValid(String email) {
    final emailRegex = regex(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<bool> exists(String email) async {
    try {
      // Check if the email exists in the backend
      final isEmailAvailable = await _authRemoteDataSource.isEmailAvailable(email);
      return !isEmailAvailable;
    } catch (e) {
      // Handle any errors that occur during the API call
      return false;
    }
  }
}