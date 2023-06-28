import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_and_register_with_api/model/signin_model.dart';
import 'package:login_and_register_with_api/providers/signin_provider.dart';
import 'package:login_and_register_with_api/providers/signup_provider.dart';
import 'package:login_and_register_with_api/screens/signin_screen.dart';
import 'package:login_and_register_with_api/screens/signup_confirmtion.dart';

import 'package:provider/provider.dart';

import '../model/signup_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_SignupScreenState>()
      : context.findAncestorStateOfType<_SignupScreenState>();

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

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

  Future<void> _signup() async {
    String username = _usernameTextController.text.trim();
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();
    SignUpBody signUpBody =
        SignUpBody(username: username, email: email, password: password);
    var provider = Provider.of<SignUpProvider>(context, listen: false);
    await provider.postData(signUpBody);
    if (provider.isBack) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupConfirmtionPage()),
      );
    } else {
      _showMyDialog(provider.data["message"]);
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameTextController.text = "test";
    _emailTextController.text = "test@gmail.com";
    _passwordTextController.text = "123456";
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _usernameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: Consumer<SignInProvider>(builder: (context, data, child) {
          return data.loading
              ? Center(
                  child: Container(
                    child: SpinKitThreeBounce(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: index.isEven ? Colors.cyan : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                          controller: _usernameTextController,
                          decoration: InputDecoration(labelText: 'Username'),
                          keyboardType: TextInputType.name,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Username can't be empty";
                            }

                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: _emailTextController,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Email can't be empty";
                            }

                            return null;
                          }),
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
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return "Password is required";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTextController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return "Confirm Password is required";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          _signup();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('Signup'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('I have account'),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }));
  }
}
