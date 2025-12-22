class RegisterModel {
  String fullName;
  String email;
  String phoneNumber;
  String userType;
  String token;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.token,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      fullName: json['fullname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userType: json['userType'],
      token: json['token'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'token': token,
    };
  }
}


class UserTypeModel {
  final String name;

  UserTypeModel(this.name);
}