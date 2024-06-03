class LoginResponse {
  final String message;
  final UserData data;

  LoginResponse({required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String customerId;
  final String name;
  final String emailAddress;
  final String mobileNo;
  final int role;
  final String referCode;

  UserData({
    required this.customerId,
    required this.name,
    required this.emailAddress,
    required this.mobileNo,
    required this.role,
    required this.referCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      customerId: json['CustomerId'],
      name: json['Name'],
      emailAddress: json['EmailAddress'],
      mobileNo: json['MobileNo'],
      role: json['Role'],
      referCode: json['ReferCode'],
    );
  }
}