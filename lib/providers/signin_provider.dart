import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:login_and_register_with_api/model/signin_model.dart';
import 'package:login_and_register_with_api/services/signin_service.dart';

class SignInProvider extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;
  String msg = '';

  var data;
  Future<void> postData(SignInBody body) async {
    print(body.toJson());
    loading = true;
    notifyListeners();
    http.Response response = (await login(body))!;
    if (response.statusCode == 200) {
      isBack = true;
      print(response.statusCode);
    } else {
      msg = 'Signin Error';
    }
    data = jsonDecode(response.body.toString());
    loading = false;

    print(isBack);
    print(data);
    notifyListeners();
  }
}
