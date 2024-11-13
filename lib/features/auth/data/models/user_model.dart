import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final DateTime _dob; // this is private variable `dob` getter is defined later.

  @HiveField(4)
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
