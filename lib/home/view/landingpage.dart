
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

    try {
      final response = await http.get(
        Uri.parse('http://172.105.154.202:8000/api/mobileusers'),
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = jsonDecode(response.body);

        // Ensure that data is a List<Map<String, dynamic>>
        if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
          setState(() {
            userData = data.cast<Map<String, dynamic>>();
          });
        } else {
          print('Invalid API response format');
        }
      } else {
        // Handle non-200 status code
        print('Failed to load data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error fetching data: $e');
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
    // await  fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 4, 12, 73),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            SizedBox(height: 10),
            AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.black26,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Alumni List',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  final user = userData[index];
                  return Column(
                    children: [
                      UserCard(user: user),
                      if (index < userData.length - 1) Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

