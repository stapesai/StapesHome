class CompleteSignup {
  User? user;
  String? password;
  String? transactionId;

  CompleteSignup({this.user, this.password, this.transactionId});

  CompleteSignup.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    password = json['password'];
    transactionId = json['transaction_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['password'] = password;
    data['transaction_id'] = transactionId;
    return data;
  }
}

class User {
  String? email;
  String? firstName;
  String? lastName;
  String? dob;
  String? gender;

  User({this.email, this.firstName, this.lastName, this.dob, this.gender});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['dob'] = dob;
    data['gender'] = gender;
    return data;
  }
}
