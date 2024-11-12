// TODO: @gauransh415

import 'dart:convert';

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String dob; //
  final String gender;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
  });

  Object toJson() {
    return jsonEncode({ 
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'gender' : gender,
    });
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dob: json['dob'], //
      gender: json['gender'],
    );
  }
}

