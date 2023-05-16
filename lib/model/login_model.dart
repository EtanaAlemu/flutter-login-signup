import 'dart:convert';

LoginResponse loginResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return LoginResponse.fromJson(jsonData);
}

String loginResponseToJson(LoginResponse data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LoginResponse {
  String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
