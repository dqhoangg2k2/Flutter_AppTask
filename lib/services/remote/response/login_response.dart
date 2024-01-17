class LoginResponse {
  String? token;

  LoginResponse();

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse()..token = json['token'] as String?;

  // Map<String, dynamic> toJson() {
  //   return {'token': token};
  // }
}
