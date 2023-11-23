import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:msualumini/auth/provider.dart';
import 'package:msualumini/auth/welcome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home.dart';
import '../auth/signup.dart';
import '../components/formfield.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  double _sigmaX = 5;
  double _sigmaY = 5;
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;


  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/bg.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 1).withOpacity(_opacity),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.63,
                        child: Form(
                          key: _formKey,
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Positioned(
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage('assets/images/bg.jpg'),
                                    ),
                                  ),
                                  Text(
                                    "Password Reset",
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                  MyTextField(
                                    controller: emailController,
                                    hintText: 'Email',
                                    obscureText: false,
                                  ),
                                  const SizedBox(height:10),

                                  ElevatedButton(
                                    onPressed: isLoading
                                        ? null // Disable the button while loading
                                        : () async {
                                      try {
                                        setState(() {
                                          isLoading = true; // Set loading state to true
                                        });



                                        setState(() {
                                          isLoading = false; // Set loading state back to false
                                        });
                                      } catch (e) {
                                        print('An error occurred during password reset: $e');
                                        // Handle the error gracefully, such as displaying an error message to the user

                                        setState(() {
                                          isLoading = false; // Set loading state back to false in case of error
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      onPrimary: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                    child: isLoading
                                        ? CircularProgressIndicator() // Loading circle animation
                                        : Text('RESET', style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(height: 10),

                                  // not a member? register now
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Remember your password?',
                                              style: TextStyle(color: Colors.white, fontSize: 15),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => WelcomePage(),
                                                  ),
                                                );

                                              },
                                              child: Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                    color: Color.fromARGB(255, 4, 46, 124),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.01),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}