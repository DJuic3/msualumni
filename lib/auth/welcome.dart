import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:msualumini/auth/passwordreset.dart';
import 'package:msualumini/auth/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home.dart';
import '../auth/signup.dart';
import '../components/formfield.dart';
import 'package:http/http.dart' as http;

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  double _sigmaX = 5;
  double _sigmaY = 5;
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;

  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Logging In'),
            content: CircularProgressIndicator(),
          );
        },
      );

      final response = await http.post(
        Uri.parse('http://172.105.154.202:8000/api/login'),
        body: {'email': email, 'password': password},
      );

      // Close loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (responseData.containsKey('token')) {
          final token = responseData['token'];
          print('Login successful');

          // Save the token to SharedPreferences
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('userToken', token);

          // Navigate to the HomeScreen upon successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        } else {
          showErrorMessage(context, 'Server did not return a token.');
        }
      } else if (response.statusCode == 401) {
        showErrorMessage(context, 'Wrong credentials');
      } else {
        showErrorMessage(context, 'Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during login: $e');
      showErrorMessage(context, 'Error during login: $e');
    }
  }

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

  // Future<void> checkExistingToken() async {
  //   final sharedPreferences = await SharedPreferences.getInstance();
  //   final token = sharedPreferences.getString('userToken');
  //
  //   if (token != null) {
  //     // Token exists, navigate to HomeScreen directly
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomeScreen(),
  //       ),
  //     );
  //   }
  // }
  Future<void> checkExistingToken(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('userToken');

    if (token != null) {
      // Set the token in the provider
      Provider.of<AuthProvider>(context, listen: false).setUserToken(token);

      // Navigate to HomeScreen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

      @override
  void initState() {
    super.initState();
    checkExistingToken(context);
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
                      "MSU ALUMNI",
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
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: false,
                        ),
                        const SizedBox(height:10),

                        // ElevatedButton(
                        //   onPressed: () async {
                        //     try {
                        //
                        //       // checkEmailAndAuthenticate(context, emailController.text);
                        //       handleLogin(context);
                        //     } catch (e) {
                        //       print('An error occurred during login: $e');
                        //       // Handle the error gracefully, such as displaying an error message to the user
                        //     }
                        //   },
                        //   style: ElevatedButton.styleFrom(
                        //     primary: Colors.transparent, // Background color
                        //     onPrimary: Colors.white, // Text color
                        //     padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16), // Adjust padding as needed
                        //     side: BorderSide(color: Colors.black), // Border color
                        //   ),
                        //   child: Text('LOGIN', style: TextStyle(color: Colors.white)), // Button text
                        // ),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null // Disable the button while loading
                              : () async {
                            try {
                              setState(() {
                                isLoading = true; // Set loading state to true
                              });

                              loginUser(context, emailController.text, passwordController.text);

                              setState(() {
                                isLoading = false; // Set loading state back to false
                              });
                            } catch (e) {
                              print('An error occurred during login: $e');
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
                              : Text('LOGIN', style: TextStyle(color: Colors.white)),
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
                                              'Don\'t have an account?',
                                              style: TextStyle(color: Colors.white, fontSize: 15),
                                              textAlign: TextAlign.start,
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Signup(),
                                                  ),
                                                );

                                              },
                                              child: Text(
                                                'SIGN UP',
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
                                        GestureDetector(
                                          onTap: () {

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ForgotPassword(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Forgot Email?',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 4, 46, 124),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        )
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