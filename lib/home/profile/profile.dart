import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profileData = "Loading..."; // Displayed profile data

  @override
  void initState() {
    super.initState();
    fetchProfileData(); // Fetch profile data when the screen loads
  }

  Future<void> fetchProfileData() async {
    try {
      // Retrieve the user's authentication token from SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      final userToken = sharedPreferences.getString('userToken');

      if (userToken == null) {
        // Handle the case where the user is not authenticated.
        setState(() {
          profileData = "User not authenticated";
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://172.105.154.202:8000/api/user/profile'),
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          profileData = "Name: ${data['name']}\nEmail: ${data['email']}\n"; // Customize this to match your API response
        });
      } else {
        // Handle errors here
        setState(() {
          profileData = "Failed to fetch profile data";
        });
      }
    } catch (e) {
      setState(() {
        profileData = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Profile'),
      ),
      body: Center(
        child: Text(profileData),
      ),
    );
  }
}
