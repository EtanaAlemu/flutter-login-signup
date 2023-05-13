import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:login_and_register_with_api/login.dart';
import '../model/login_model.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String url = 'https://127.0.0.1:10000/api/v1/login';
Future<http.Response> login(User user) async {
  final response =
      await http.post(Uri.parse('https://127.0.0.1:10000/api/v1/login'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: ''
          },
          body: userToJson(user));

  return response;
}

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
