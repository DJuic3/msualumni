import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';




final String apiUrl = 'http://172.105.154.202:8000/api/posts';

Future<void> createBlogPost(Map<String, dynamic> postData) async {
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer YourAccessToken', // Include the user's access token
    },
    body: jsonEncode(postData),
  );

  if (response.statusCode == 201) {
    // Blog post created successfully
  } else {
    // Handle errors
  }
}

class CreateBlogPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post',
        ),
        backgroundColor: Colors.black45, // Set the background color to transparent
        elevation: 0, // Remove the shadow
      ),
      body: ListView(
          children: <Widget>[
      Image.asset('assets/images/bg.jpg'), // Add your image asset
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlogPostForm(),
      ),
      ]
      )
    );
  }
}

class BlogPostForm extends StatefulWidget {
  @override
  _BlogPostFormState createState() => _BlogPostFormState();
}

class _BlogPostFormState extends State<BlogPostForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController contactemailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController educationController = TextEditingController();

  String? titleError = null; // Initialize with null
  String? contentError = null; // Initialize with null
  String? contactemailError = null;
  String? companyError = null;
  String? positionError = null;
  String? locationError = null;
  String? educationError = null;

  void _submitForm() async {
    final String apiUrl = 'http://172.105.154.202:8000/api/posts'; // Replace with your API URL

    final Map<String, dynamic> postData = {
      'title': titleController.text,
      'content': contentController.text,
      'contactemail': contactemailController.text,
      'company': companyController.text,
      'position': positionController.text,
      'location': locationController.text,
      'education': educationController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 201) {
      // Blog post created successfully
      print('Blog post created successfully');
      Fluttertoast.showToast(
        msg: 'Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Clear text fields after successful submission
      titleController.clear();
      contentController.clear();
      contactemailController.clear();
      companyController.clear();
      positionController.clear();
      locationController.clear();
      educationController.clear();
    } else {
      // Handle errors
      print('Error creating blog post: ${response.body}');
      Fluttertoast.showToast(
        msg: 'Not done',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: 'Enter your title', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: contactemailController,
          decoration: InputDecoration(
            labelText: 'Contact Email',
            hintText: 'Enter your email', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: companyController,
          decoration: InputDecoration(
            labelText: 'Company',
            hintText: 'Enter recruting company', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: positionController,
          decoration: InputDecoration(
            labelText: 'Position',
            hintText: 'Enter vacant position', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            hintText: 'Enter location', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: educationController,
          decoration: InputDecoration(
            labelText: 'Education',
            hintText: 'Enter highest education required', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: contentController,
          maxLines: 9, // Increase the number of lines to make it taller
          textAlignVertical: TextAlignVertical.top, // Align the text at the top
          decoration: InputDecoration(
            labelText: 'Content',
            hintText: 'Write your content here', // Placeholder text
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0), // Add rounded corners
            ),
            filled: true, // Add a white background
            fillColor: Colors.transparent, // Set the background color to white
          ),
        ),

        SizedBox(height: 30),
        InkWell(
          onTap: _submitForm,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green, // Set the container's background color to transparent
              border: Border.all(color: Colors.black), // Add a black border around the container
              borderRadius: BorderRadius.circular(8.0), // You can adjust the border radius as needed
            ),
            padding: EdgeInsets.all(12.0), // Add padding to the container
            alignment: Alignment.center, // Center the child (text) within the container
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.black, // Set the text color to black
                fontSize: 18.0, // You can adjust the font size as needed
              ),
            ),
          ),
        )

        // ElevatedButton(
        //   onPressed: _submitForm,
        //   child: Text('Create Blog Post'),
        // ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateBlogPostScreen(),
  ));
}
