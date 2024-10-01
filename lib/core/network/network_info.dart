// File: lib/core/network/network_info.dart
// Description: This file contains the NetworkInfo class, which provides information about the device's network connectivity.

import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract class defining the contract for network information
abstract class NetworkInfo {
  /// Checks if the device is currently connected to the internet
  Future<bool> get isConnected;
}

/// Implementation of [NetworkInfo] using [InternetConnectionChecker]
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  /// Creates a new [NetworkInfoImpl] instance
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
