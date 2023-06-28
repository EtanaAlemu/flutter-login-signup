import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_and_register_with_api/model/signin_model.dart';
import 'package:login_and_register_with_api/config/constraints.dart';

Future<http.Response?> login(SignInBody data) async {
  http.Response? response;
  try {
    print("++++++++++++++++++++++++++++");
    response = await http.post(Uri.parse(BASE_URL + LOGIN),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(data.toJson()));
  } catch (e) {
    print("LOGIN ERROR: " + e.toString());
  }
  return response;
}
