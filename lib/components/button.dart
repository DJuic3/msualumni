import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:msualumini/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/signup.dart';
import 'package:http/http.dart' as http;


class MyButton extends StatelessWidget {
  final Function()? onTap;
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   MyButton({super.key, required this.onTap});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   const AddAccountPage();
      // },
      // onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 4, 46, 124),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Continue",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class MyButtonAgree extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButtonAgree({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){ HomeScreen();
        },
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 6, 40, 105),
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
    );
  }
}