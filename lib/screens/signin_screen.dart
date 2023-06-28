import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_and_register_with_api/model/signin_model.dart';
import 'package:login_and_register_with_api/providers/signin_provider.dart';
import 'package:login_and_register_with_api/screens/signup_screen.dart';
import 'package:login_and_register_with_api/screens/token_screen.dart';
import 'package:login_and_register_with_api/utils/secure_storage.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_LoginScreenState>()
      : context.findAncestorStateOfType<_LoginScreenState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    SignInBody signInBody = SignInBody(email: email, password: password);
    print(
        "===================================================================");
    var provider = Provider.of<SignInProvider>(context, listen: false);
    await provider.postData(signInBody);
    if (provider.isBack) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TokenPage()),
      );

      SecureStorage.putString("token", provider.data["token"]);
      SecureStorage.putString("email", email);
      SecureStorage.putString("password", password);
    } else {
      _showMyDialog(provider.data["message"]);
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = "etanaalemunew@gmail.com";
    _passwordController.text = "Eviot@10908";
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
                          controller: _emailController,
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
                        controller: _passwordController,
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
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          _login();
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('I wanna create account'),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        }));
  }
}
