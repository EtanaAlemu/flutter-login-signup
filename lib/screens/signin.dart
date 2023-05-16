import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:login_and_register_with_api/screens/token_screen.dart';
import 'package:login_and_register_with_api/widgets/app_text_field.dart';
import 'package:provider/provider.dart';

import 'package:login_and_register_with_api/main_page.dart';
import 'package:login_and_register_with_api/model/signin_model.dart';
import 'package:login_and_register_with_api/providers/signin_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

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

    Future<void> _login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      SignInBody signInBody = SignInBody(email: email, password: password);
      var provider = Provider.of<SignInProvider>(context, listen: false);
      await provider.postData(signInBody);
      if (provider.isBack) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TokenPage()),
        );
      } else {
        _showMyDialog(provider.data["message"]);
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Consumer<SignInProvider>(builder: (context, data, child) {
          return data.loading
              ? Center(
                  child: Container(
                    child: SpinKitThreeBounce(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 100),
                      //app logo
                      Container(
                          height: 100,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 80,
                            ),
                          )),

                      AppTextField(
                          textController: emailController,
                          hintText: "Email",
                          icon: Icons.email),
                      SizedBox(
                        height: 20,
                      ),
                      AppTextField(
                          textController: passwordController,
                          hintText: "Password",
                          icon: Icons.password_sharp,
                          isObscure: true),
                      SizedBox(
                        height: 20 + 20,
                      ),
                      //sign up button
                      GestureDetector(
                        onTap: () {
                          _login();
                        },
                        child: Container(
                          height: 70,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 23),
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF74beef),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(4, 4),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4, -4),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //tag line
                      RichText(
                          text: TextSpan(
                              text: "Have an account already?",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 20))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      //sign up options
                      RichText(
                          text: TextSpan(
                              text:
                                  "Sign up using one of the following methods",
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 16))),
                    ],
                  ),
                );
        }));
  }
}
