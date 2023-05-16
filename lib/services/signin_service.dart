import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:login_and_register_with_api/model/signin_model.dart';

Future<http.Response?> login(SignInBody data) async {
  http.Response? response;
  try {
    response = await http.post(Uri.parse("http://localhost:10000/api/v1/login"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}
