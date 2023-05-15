import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_and_register_with_api/login.dart';
import '../model/user_model.dart';
import '../model/login_model.dart';
import '../config/constraints.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_error.dart';
import 'api_response.dart';

String url = 'https://127.0.0.1:10000/api/v1/login';
void loginToServer(User user) async {
  final response =
      await http.post(Uri.parse('https://127.0.0.1:10000/api/v1/login'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: ''
          },
          body: {"email":user.email,"password":user.password});

  if (response.statusCode == 200) {
    return jsonDecode( response.body.toString());
  } else {
    return null;
  }
}

Future<ApiResponse> authenticateUser(String email, String password) async {
  ApiResponse _apiResponse = new ApiResponse();

  try {
    final response = await http.post(Uri.parse(Constraints.BASE_URL+Constraints.LOGIN), body: {
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        _apiResponse.Data =  LoginResponse.fromJson(json.decode(response.body));
        print("200");
        break;
      case 401:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        print("401");
        break;
      default:
        _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        print("def");
        break;
    }
  } on SocketException {
    _apiResponse.ApiError = ApiError(error: "Server error. Please retry");
    
        print("error");
  }
  print(_apiResponse.Data);
  return _apiResponse;
}

// Future<User> login(String email, password) async {
  //   try {
      
  //     Response response = await post(Uri.parse('https://localhost:10000/api/v1/login'),
  //         body: {'email': email, 'password': password});

  //     var data = jsonDecode(response.body.toString());
  //     if (response.statusCode == 200) {
  //       print(data['token']);
  //       print('Login successfully');

  //       // Create storage
  //       final storage = new FlutterSecureStorage();
  //       setState(() {
  //         _isLoading = false;
  //         // Write value
  //         storage.write(key: 'jwt', value: data['token']);
  //         Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(
  //               builder: (BuildContext context) => MainPageScreen(),
  //             ),
  //             (Route<dynamic> route) => false);
  //       });
  //       return User.fromJson(data.decoder(response.body));
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //         _showMyDialog(data['message']);
  //       });
  //       throw Exception('Failed to login');
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     throw Exception('Error'+e.toString());
  //   }
  // }


Future<dynamic> sendRequestToServer(
    dynamic model, String reqType, bool isTokenHeader, String token) async {
  HttpClient client = new HttpClient();

  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client.postUrl(Uri.parse(url));
  request.headers.set('Content-Type', 'application/json');
  if (isTokenHeader) {
    request.headers.set('Authorization', 'Bearer $token');
  }
  request.add(utf8.encode(jsonEncode(model)));
  HttpClientResponse result = await request.close();
  if (result.statusCode == 200) {
    return jsonDecode(await result.transform(utf8.decoder).join());
  } else {
    return null;
  }
}
