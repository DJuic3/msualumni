import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  String? userToken;

  void setUserToken(String? token) {
    userToken = token;
    notifyListeners();
  }
}
