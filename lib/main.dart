// File: lib/main.dart
// Description: This file contains the main application entry point.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/colors.dart';
import 'core/routes/router.dart';
import 'data/datasources/user_local_data_source.dart';
import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/update_user_profile.dart';
import 'domain/usecases/request_login.dart';
import 'domain/usecases/complete_login.dart';
import 'domain/usecases/request_signup.dart';
import 'domain/usecases/complete_signup.dart';
import 'domain/usecases/request_password_reset.dart';
import 'domain/usecases/complete_password_reset.dart';
import 'domain/usecases/verify_otp.dart';
import 'domain/usecases/logout.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/user/user_bloc.dart';
import 'core/network/http_client.dart';
import 'core/network/network_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Register Hive adapters
  Hive.registerAdapter(UserModelAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            requestLogin: RequestLogin(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            completeLogin: CompleteLogin(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            requestSignup: RequestSignup(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            completeSignup: CompleteSignup(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            requestPasswordReset: RequestPasswordReset(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            completePasswordReset: CompletePasswordReset(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            verifyOtp: VerifyOtp(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            logout: Logout(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
          ),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            getCurrentUser: GetCurrentUser(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
            updateUserProfile: UpdateUserProfile(
              UserRepositoryImpl(
                remoteDataSource: UserRemoteDataSourceImpl(client: HttpClient()),
                localDataSource: UserLocalDataSourceImpl(sharedPreferences: SharedPreferences.getInstance()),
                networkInfo: NetworkInfoImpl(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Stapes Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: AppColor.backgroundColorDark,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: AppColor.whiteColor),
            bodyText2: TextStyle(color: AppColor.whiteColor),
          ),
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
