
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: UserListScreen(),
  ));
}

class UserDetails extends StatelessWidget {
  final Map<String, dynamic> user;

  UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALUMNI ID: ${user['id']}', // Add user ID
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Email: ${user['email']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Date of Birth: ${user['selected_date']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Graduation Year: ${user['graduation_date']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Gender: ${user['gender']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Area of Work: ${user['repeat']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Employment Status: ${user['employment_status']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Phone Number: ${user['phone']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),
        Text(
          'Country: ${user['country']}',
          style: TextStyle(
            fontSize: 15, // Increase font size
            fontWeight: FontWeight.bold, // Make text bolder
            height: 1.5, // Increase line height
          ),
        ),

        // Add more user details as needed
      ],
    );
  }



}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(user['name']),
      children: <Widget>[
        UserDetails(user: user),
      ],
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> userData = [];
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    // fetchUsers();
    fetchData();
  }

  // Future<void> fetchUsers() async {
  //   final response = await http.get(Uri.parse('http://172.105.154.202:8000/api/mobileusers'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = json.decode(response.body);
  //     setState(() {
  //       users = jsonData.cast<Map<String, dynamic>>();
  //     });
  //   } else {
  //     throw Exception('Failed to load users');
  //   }
  // }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    final response = await http.get(
      Uri.parse('http://172.105.154.202:8000/api/mobileusers'),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      setState(() {
        userData = data;
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 4, 12, 73),
      body: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: const Row(
              children: [
                Text(
                  'Alumni List',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 16), // Add some spacing between the text and image
                // Image.asset(
                //   'assets/images/midlands.jpeg', // Replace with the actual image path
                //   width: 50, // Set the width of the image
                //   height: 50, // Set the height of the image
                // ),
              ],
            ),


          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Column(
                  children: [
                    UserCard(user: user),
                    if (index < users.length - 1) Divider(), // Add Divider for all except the last item
                  ],
                );
              },
            ),
          ),



        ],
      ),
    );

  }


}


