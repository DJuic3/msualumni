import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/pallete.dart';



class BlogPostsScreen extends StatefulWidget {
  @override
  _BlogPostsScreenState createState() => _BlogPostsScreenState();
}

class _BlogPostsScreenState extends State<BlogPostsScreen> {
  List<dynamic> posts = [];
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final apiUrl = 'http://172.105.154.202:8000/api/posts'; // Replace with your API URL

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      try {
        final responseData = json.decode(response.body);
        setState(() {
          posts = responseData['posts'];
        });
      } catch (e) {
        print('Error decoding JSON: $e');
        print('Response body: ${response.body}');
      }
    } else {
      // Handle errors, e.g., show an error message
      print('API request failed with status code: ${response.statusCode}');
    }
  }
  Future<void> _refreshPosts() async {
    await _fetchPosts();
  }
  void shareContent(String title, String content) {
    Share.share('Check out this post by Msu Alumni: \nTitle: $title\nContent: $content');
  }
  Future<void> requestAndShare() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Permission is granted, so you can share content
      Share.share('Check out this amazing content!');
    } else {
      // Permission is denied. Handle accordingly, e.g., show a message to the user.
      print('Storage permission is required for sharing content.');
    }
  }
  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
  // Function to open Gmail
  void openGmail() async {
    // Specify the email address
    String email = '';

    // Create the Gmail URL
    String gmailUrl = 'mailto:$email';

    // Encode the URL
    String encodedGmailUrl = Uri.encodeFull(gmailUrl);

    // Launch the URL
    if (await canLaunch(encodedGmailUrl)) {
      await launch(encodedGmailUrl);
    } else {
      // Handle error
      throw 'Could not launch $encodedGmailUrl';
    }
  }


  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    Color textColor = brightness == Brightness.dark ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacancies'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      backgroundColor: Colors.white,

      body: RefreshIndicator(
        onRefresh: () => _refreshPosts(), // Modify to refresh profile data
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            int likeCount = post['likeCount'] ?? 0;
            bool isLiked = post['isLiked'] ?? false;

    void handleLikeButtonPress() {
            int postId = post['id'];

            String apiUrl = 'http://172.105.154.202:8000/api/posts/$postId/like';
            http.post(Uri.parse(apiUrl)).then((response) {
              if (response.statusCode == 200) {
                setState(() {
                  isLiked = true; // Update isLiked to true
                  likeCount++;
                });
                Fluttertoast.showToast(msg: 'Post liked successfully');
              } else {
                print('Failed to like the post. Error: ${response.statusCode}');
              }
            }).catchError((error) {
              print('Error occurred while liking the post: $error');
            });
          }

            return Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Card(
                elevation: 0, // Remove the default card elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        post['title'],
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Company: ${post['company']}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.blue[500],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        post['content'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Text(
                        'Show More',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  color: Colors.black12,
                                  child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Contact Email:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    post['contactemail'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Company:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    post['company'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Position:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    post['position'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Location:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    post['location'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Education:',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    post['education'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Intel',
                                                    ),
                                                  ),
                                                ),



                                              ],
                                            ),
                                            SizedBox(height: 20),  // Add some spacing between text and image
                                            Image.asset(
                                              'assets/images/bg.jpg',  // Replace with your image URL
                                              width: double.infinity,  // Set the width of the image
                                              height: 165,  // Set the height of the image
                                              fit: BoxFit.cover,  // Choose the BoxFit property as needed
                                            ),
                                            Expanded(child: SizedBox(height: 16)),
                                            Container(
                                              width: double.infinity,

                                              child: ElevatedButton(
                                                child: const Text(
                                                  'Apply Now',

                                                  style: TextStyle(fontSize: 18),

                                                ),

                                                onPressed: () {
                                                  // Navigator.pop(context);
                                                  openGmail();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                              );
                            },
                          );
                        }
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              size: 15,
                              color: isLiked ? Colors.blue : Colors.grey,
                            ),
                            onPressed: handleLikeButtonPress,
                          ),
                          Text(
                            'Likes: $likeCount',
                            style: GoogleFonts.roboto(
                              color: Colors.blue[800],
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => shareContent(post['title'], post['content']),
                            child: Icon(
                              Icons.share,
                              size: 15,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );


          },
        ),
      ),
    );
  }

}
