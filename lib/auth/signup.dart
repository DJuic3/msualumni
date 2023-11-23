import 'dart:convert';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../components/formfield.dart';
import '../home/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences


class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password_confirmation = TextEditingController();
  final TextEditingController name = TextEditingController();

  Future<void> registerUser(BuildContext context, String email, String name, String password, String password_confirmation) async {
    try {
      print('Registering User - Request Data:');
      print('Name: $name');
      print('Email: $email');
      print('Password: $password');
      print('Password Confirmation: $password_confirmation');
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent user from closing the dialog
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Registering User'),
          content: SizedBox(
          width: 0.5, // Set your desired width
          height: 0.5, // Set your desired height
          child: CircularProgressIndicator(),
          ),
          );
        },
      );

      final response = await http.post(
        Uri.parse('http://172.105.154.202:8000/api/register'),
        // headers: {'Accept': 'application/json'},
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password_confirmation,
        }),
      );


      // Close loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final userToken = responseData['token'];
        print(userToken);
        if (responseData.containsKey('token')) {
          final userToken = responseData['token'];

          // Save the user token to SharedPreferences
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('userToken', userToken);

          // Navigate to the HomeScreen upon successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
        else {
          showErrorMessage(context, 'Server did not return a user token.');
        }
      } else if (response.statusCode == 422) {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'];
        final errors = errorResponse['errors'];

        if (errors != null && errors.containsKey('password')) {
          final passwordErrors = errors['password'];
          final passwordErrorMessage = passwordErrors.isNotEmpty ? passwordErrors[0] : 'Password confirmation did not match.';
          showErrorMessage(context, passwordErrorMessage);
        } else {
          showErrorMessage(context, errorMessage);
        }
      } else {
        print('Unexpected response:');
        print('Status code: ${response.statusCode}');
        print('Headers: ${response.headers}');
        print('Body: ${response.body}');
        showErrorMessage(context, 'An unexpected error occurred. Please try again later.');
      }
    } catch (e) {
      print('Error during registration: $e');
      showErrorMessage(context, 'Error during registration: $e');
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Try Again'),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service and Privacy Policy'),
          content: Text(
            'By using this app, you agree to the following terms and conditions regarding the collection and use of your personal data: \n 1. Collection of Personal Information:We may collect personal information from you, such as your name, email address, and other relevant details when you register or interact with our app. This information is collected for the purpose of providing you with a personalized and enhanced user experience.'
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
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
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SizedBox(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.26),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ClipRect(
                    child: BackdropFilter(
                      filter:
                      ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 1)
                                .withOpacity(_opacity),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.51,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [

                                const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30),

                                MyTextField(
                                  controller: name,
                                  hintText: 'Name',
                                  obscureText: false,
                                ),
                                const SizedBox(height: 5),

                                MyTextField(
                                  controller: email,
                                  hintText: 'Email',
                                  obscureText: false,
                                ),

                                const SizedBox(height: 5),
                                MyPasswordTextField(
                                  controller: password,
                                  hintText: 'Password',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 5),
                                MyPasswordTextField(
                                  controller: password_confirmation,
                                  hintText: 'Password Confirmation',
                                  obscureText: true,
                                ),
                                const SizedBox(height: 30),

                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: 'By using this app, you agree to our ',
                                        children: [
                                          TextSpan(
                                            text: 'Terms of Service and Privacy Policy',
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 71, 233, 133),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                showTermsAndConditionsDialog(context);
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    InkWell(
                                      onTap: () {
                                        registerUser(
                                          context,
                                          email.text,
                                          name.text,
                                          password.text,
                                          password_confirmation.text,);
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => ()
                                        //
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent, // Set the container's background color to transparent
                                          border: Border.all(color: Colors.black), // Add a black border around the container
                                          borderRadius: BorderRadius.circular(8.0), // You can adjust the border radius as needed
                                        ),
                                        padding: EdgeInsets.all(12.0), // Add padding to the container
                                        alignment: Alignment.center, // Center the child (text) within the container
                                        child: const Text(
                                          "Agree and Continue",
                                          style: TextStyle(
                                            color: Colors.black, // Set the text color to black
                                            fontSize: 18.0, // You can adjust the font size as needed
                                          ),
                                        ),
                                      ),
                                    )


                                  ],
                                ),
                              ],
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

  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;
  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() {
    if (_formKey.currentState!.validate()) {
      print('valid');
    } else {
      print('not valid');
    }
  }


