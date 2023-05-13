import 'package:flutter/material.dart';
import './main_page.dart';
// import './services/login_service.dart';
import './model/login_model.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<User> login(String email, password) async {
    try {
      
      Response response = await post(Uri.parse('https://localhost:10000/api/v1/login'),
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => MainPageScreen(),
              ),
              (Route<dynamic> route) => false);
        });
        return User.fromJson(data.decoder(response.body));
      } else {
        setState(() {
          _isLoading = false;
          _showMyDialog(data['message']);
        });
        throw Exception('Failed to login');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error'+e.toString());
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
                    autocorrect: false,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoading = true;
                      });
                      login(_emailTextController.text.toString(),
                          _passwordTextController.text.toString());
                      // login(
                      //   new User(
                      //       email: _emailTextController.text.toString(),
                      //       password: _passwordTextController.text.toString()),
                      // );
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
