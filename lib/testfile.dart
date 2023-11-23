
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Showmore extends StatelessWidget {
  // Example data from the API
  final Map<String, dynamic> post = {
    'content': 'Lorem ipsum dolor sit amet...',
    'contactemail': 'example@example.com',
    'company': 'ABC Company',
    'position': 'Software Engineer',
    'location': 'New York',
    'education': 'Bachelor of Science',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            post['content'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 8),
          InkWell(
            child: Text(
              'Show More',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                // decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contact Email: ${post['contactemail']}'),
                        Text('Company: ${post['company']}'),
                        Text('Position: ${post['position']}'),
                        Text('Location: ${post['location']}'),
                        Text('Education: ${post['education']}'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'input.dart';



class UserData {
  final String selectedDate;
  final String graduationDate;
  final String gender;
  final String email;
  final String repeat;
  final String employmentStatus;
  final String phone;
  final String name;
  final String country;

  UserData({
    required this.selectedDate,
    required this.graduationDate,
    required this.gender,
    required this.email,
    required this.repeat,
    required this.employmentStatus,
    required this.phone,
    required this.name,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'selected_date': selectedDate,
      'graduation_date': graduationDate,
      'gender': gender,
      'email': email,
      'repeat': repeat,
      'employment_status': employmentStatus,
      'phone': phone,
      'name': name,
      'country': country,
    };
  }
}

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({Key? key}) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _selectedDateController = TextEditingController();
  final TextEditingController _graduationDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();
  final TextEditingController _employmentStatusController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Future<void> UpdateUser(UserData userData) async {
    final url = Uri.parse('http://172.105.154.202:8000/api/user-data');

    try {
      final response = await http.post(
        url,
        body: userData.toJson(),
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
      } else {
        print('Failed to register user: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
  void _showDatePicker(BuildContext context) {
    final initialDateTime = DateTime.now();
    final minimumYear = initialDateTime.year - 100;
    final maximumYear = initialDateTime.year + 100;


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _selectedDateController,
                    decoration: InputDecoration(
                      labelText: 'Date of birth',
                    ),
                    onTap: () {
                      _showDatePicker(context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the birth of date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _graduationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Graduation Date',
                    ),
                    onTap: () {
                      _showDatePicker(context);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the graduation date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _genderController,
                    decoration: InputDecoration(labelText: 'Gender'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the gender';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _repeatController,
                    decoration: InputDecoration(labelText: 'Repeat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the repeat value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _employmentStatusController,
                    decoration: InputDecoration(labelText: 'Employment Status'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the employment status';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _countryController,
                    decoration: InputDecoration(labelText: 'Country'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the country';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final userData = UserData(
                            selectedDate: _selectedDateController.text,
                            graduationDate: _graduationDateController.text,
                            gender: _genderController.text,
                            email: _emailController.text,
                            repeat: _repeatController.text,
                            employmentStatus: _employmentStatusController.text,
                            phone: _phoneController.text,
                            name: _nameController.text,
                            country: _countryController.text,
                          );
                          UpdateUser(userData);
                        }
                      },
                      child: Text('Update Account')
                  )
                ],
              )
          ),
        )
    );
  }
}

