import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatelessWidget {

  Future<void> logoutUser(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Logging Out'),
            content: CircularProgressIndicator(),
          );
        },
      );

      final sharedPreferences = await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('userToken');

      if (token != null) {
        final response = await http.post(
          Uri.parse('http://172.105.154.202:8000/api/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        // Close loading indicator
        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          print('Logout successful');

          // Clear the user token from SharedPreferences
          sharedPreferences.remove('userToken');

          // Navigate to the LoginScreen upon successful logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          showErrorMessage(context, 'Logout failed: ${response.reasonPhrase}');
        }
      } else {
        // Token not found, navigate to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print('Error during logout: $e');
      showErrorMessage(context, 'Error during logout: $e');
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Failed'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              logoutUser(context);
            },
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('Welcome to the Login Screen!'),
      ),
    );
  }
}
