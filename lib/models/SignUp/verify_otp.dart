class VerifyOtp {
  String? transactionId;
  String? code;

  VerifyOtp({this.transactionId, this.code});

  VerifyOtp.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transactionId;
    data['code'] = this.code;
    return data;
  }
}
