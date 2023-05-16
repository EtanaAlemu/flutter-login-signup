import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../model/signup_model.dart';
import '../services/signup_service.dart';

class SignUpProvider extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;
  String msg = '';
  var data;
  Future<void> postData(SignUpBody body) async {
    loading = true;
    notifyListeners();
    http.Response response = (await register(body))!;
    if (response.statusCode == 201) {
      isBack = true;
    } else {
      msg = 'Signup Error';
    }
    data = jsonDecode(response.body.toString());
    loading = false;
    notifyListeners();
    print(isBack);
    print(data);
  }
}
