
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