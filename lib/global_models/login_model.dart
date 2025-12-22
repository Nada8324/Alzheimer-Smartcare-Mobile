class LogInModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? userType;
  String? token;
  String?password;

  LogInModel({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.userType,
    this.token,
    this.password
  });

  // Factory constructor for creating a new instance from a JSON map
  factory LogInModel.fromJson(Map<String, dynamic> json) {
    return LogInModel(
      fullName: json['fullname'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userType: json['userType'],
      token: json['token'],
      password:json['password'],
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
      'password':password
    };
  }
}
