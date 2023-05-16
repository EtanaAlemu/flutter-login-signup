import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/signup_model.dart';

Future<http.Response?> register(SignUpBody data) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse("http://localhost:10000/api/v1/register"),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data.toJson()));
  } catch (e) {
    log(e.toString());
  }
  return response;
}
