import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  // final usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  double _sigmaX = 5;
  double _sigmaY = 5;
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;

  Future<bool> checkEmailExistence(String email) async {
    final response = await http.get(
      Uri.parse('http://172.105.154.202:8000/api/check-email?email=$email'),
    );
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Email exists
      return true;
    } else if (response.statusCode == 404) {
      // Email does not exist
      return false;
    } else {
      // Handle other response codes or errors
      throw Exception('Failed to check email existence');
    }
  }
  Future<void> checkUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }
  void handleLogin(BuildContext context) async {
    final email = emailController.text.trim(); // Trim the email input
    final exists = await checkEmailExistence(email);

    if (exists) {
      // Email exists, navigate to HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );

      // Save the user's login credentials or authentication token to persistent storage
      saveUserLogin(email);

      // Set isLoggedIn to true in shared preferences
      saveLoginStatus(true);
    } else {
      // Email does not exist, continue with login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Signup(),
        ),
      );
    }
  }
  void saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }
  void saveUserLogin(String email) async {
    // Use a persistent storage mechanism to save the user's login credentials or authentication token
    // For example, you can use shared preferences or local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', email);
  }


      @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
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
                    const SizedBox(height: 50),

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

                               handleLogin(context);

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
                                        const Text('Forgot Email?',
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 4, 46, 124),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                            textAlign: TextAlign.start),
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