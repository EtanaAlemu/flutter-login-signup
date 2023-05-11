import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String _errMsg = "";

  void login(String email, password) async {
    try {
      Response response = await post(
          Uri.parse('http://localhost:10000/api/v1/login'),
          body: {'email': email, 'password': password});

        var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        print(data['token']);
        print('Login successfully');

        // Create storage
        final storage = new FlutterSecureStorage();
        setState(() {
          
         _isLoading = false;
        // Write value
         storage.write(key: 'jwt', value: data['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPageScreen(),), (Route<dynamic>route) => false);
        });
      } else {
        setState(() {
          
         _isLoading = false;
         _showMyDialog(data['message']);
        });
        
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _showMyDialog(msg) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Login failed'),
        content: SingleChildScrollView(
          child: Text(msg)
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isLoading? Center(child: CircularProgressIndicator(),): 
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                login(emailController.text.toString(),
                    passwordController.text.toString());
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
