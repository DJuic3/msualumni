import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String userEmailKey = 'userEmail';
  static const String userTokenKey = 'userToken';

  // Save user login information
  static Future<void> saveUserLogin(String email, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userEmailKey, email);
    prefs.setString(userTokenKey, token);
  }

  // Retrieve user email
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  // Retrieve user token
  static Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTokenKey);
  }
}
