// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:msualumini/auth/signup.dart';
import '../components/formfield.dart';
import '../home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';


class LoginPage extends StatelessWidget {
  LoginPage();

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  void checkUserLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('userEmail');
    final userToken = prefs.getString('userToken');

    if (userEmail != null && userToken != null) {
      // Both email and token exist, navigate to the HomeScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      // Either email or token is missing, navigate to the LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
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
              Image.network(
              'https://anmg-production.anmg.xyz/yaza-co-za_sfja9J2vLAtVaGdUPdH5y7gA',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.26),
        const Text("Log in",
            style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold)),


        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 1).withOpacity(_opacity),
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(children: [
                     CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://scontent.fhre2-2.fna.fbcdn.net/v/t39.30808-6/386059909_699855238849258_4149361829352165653_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=a2f6c7&_nc_ohc=E1bzvCw1bsgAX-5fAkm&_nc_ht=scontent.fhre2-2.fna&oh=00_AfDU1Sn-MHVSO0867DSAQwcJh3cZayNWcfhDl31swI33oA&oe=652025D4',
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Jane Doe",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text("jane.doe@gmail.com",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18)),
                      ],
                    ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: true,
                  ),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      loginUser(context, emailController.text, passwordController.text);
                    },
                    child: Text("Continue"),
                  ),
                  const SizedBox(height: 30),
                  const Text('Forgot Password?',
                      style: TextStyle(
                          color: Color.fromARGB(255, 71, 233, 133),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      textAlign: TextAlign.start),
                  ]
                  ),
              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ],
    ),
    ],
    ),
    ),
    ),
    );
  }
}
