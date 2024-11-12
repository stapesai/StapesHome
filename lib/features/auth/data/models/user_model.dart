import 'dart:convert';
import 'package:intl/intl.dart';

class UserModel {
  final String email;
  final String firstName;
  final String lastName;
  final DateTime _dob; // make it private
  final String gender;

  static final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required DateTime dob,
    required this.gender,
  }) : _dob = dob;

  // Getter for formatted date
  String get dob => dateFormat.format(_dob);

  Object toJson() {
    return jsonEncode({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dateFormat.format(_dob).toString(),
      'gender': gender,
    });
  }

  factory UserModel.fromJson(Map<String, dynamic> response) {
    return UserModel(
      email: response['email'],
      firstName: response['first_name'],
      lastName: response['last_name'],
      dob: DateTime.parse(response['dob']),
      gender: response['gender'],
    );
  }
}
