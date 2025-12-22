class Endpoints {
  static const String baseUrl = "https://alzheimersgp.runasp.net/api/";
  static const String testUrl = "http://localhost:5267/api/";
  static const String modelsUrl = "https://510e48ce-17c6-49c5-adda-919ff01667ee-00-25w3bmcu599ap.janeway.replit.dev/";
  static const String Register = "Account/Register";
  static const String Login = "Account/Login";
  static const String SaveFace = "FaceImages";
  static const String QrCode= "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=PAIRING_TOKEN";
  static const String ChangePassword = "Account/ChangePassword";
  static const String storedFaces = "FaceImages";
  static const String scheduleNotification="MedicineReminder";

}


class ApiKey {
  static String message = "message";
  static String status = "status";
  static String errorMessage = "errors";
  static String email = "email";
  static String password = "password";
  static String token = "token";
  static String id = "id";
  static String name = "name";
  static String phone = "phone";
  static String confirmPassword = "confirmPassword";
  static String location = "location";
  static String profilePic = "profilePic";
  static String mriPredict = "predict";
  static String faceRegister = "register";
  static String faceRecognize = "recognize";
}