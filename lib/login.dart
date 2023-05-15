import 'package:flutter/material.dart';
import 'package:login_and_register_with_api/services/api_response.dart';
import './main_page.dart';
import './services/login_service.dart';
import './model/login_model.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'services/api_error.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_LoginScreenState>()
      : context.findAncestorStateOfType<_LoginScreenState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;
  String _errMsg = "";
  bool _passwordVisible = false;

  _showMyDialog(msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login failed'),
          content: SingleChildScrollView(child: Text(msg)),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  
  void login() async {
    try {
     var _apiResponse = await authenticateUser(
          _emailTextController.text.toString(),
          _passwordTextController.text.toString());
      if ((_apiResponse.ApiError as ApiError) == null) {
       final storage = new FlutterSecureStorage();
        setState(() {
          _isLoading = false;
          // Write value
          LoginResponse res = _apiResponse.Data as LoginResponse;
          storage.write(key: 'jwt', value: res.token);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MainPageScreen(),
              ),
              (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          _isLoading = false;
          _showMyDialog((_apiResponse.ApiError as ApiError).error);
        });
      }
    
  
    } catch (e) {
      print(e.toString());
        setState(() {
          _isLoading = false;
          _showMyDialog(e.toString());
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailTextController.text = "etanaalemunew@gmail.com";
    _passwordTextController.text = "123456";
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Email can't be empty";
                        }

                        return null;
                      }
                      ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordTextController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Password is required";
                        }

                        return null;
                      },
                    
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      login();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text('Login'),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
