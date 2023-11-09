import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msualumini/home/profile/profile.dart';
import 'package:msualumini/home/store_data/accouncontroller.dart';
import 'package:msualumini/home/store_data/account_model.dart';
import 'package:msualumini/home/store_data/button.dart';
import 'package:msualumini/home/store_data/size_config.dart';
import 'package:msualumini/home/store_data/theme.dart';
import 'package:msualumini/home/store_data/ui.dart';
import 'package:msualumini/home/view/blogs.dart';
import 'package:msualumini/home/view/landingpage.dart';
import 'package:msualumini/home/view/showblogs.dart';
import 'package:msualumini/profile/details.dart';
import 'package:msualumini/testfile.dart';
import '../services/reminders.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotifyHelper notifyHelper;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    // _accountController.getAccounts();
  }


  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('MSU Tracer Survey Form'),
          content: const Text(
            'Dear Midlands State University Graduates, Share your post-graduation journey with us! Your experiences matter, and your insights will help us improve our programs for future graduates.'
                ' Take a moment to complete this Tracer Survey. '
                'Thank you for being part of our Midlands State University community!',
            style: TextStyle(fontSize: 10),),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> logoutUser(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          'http://172.105.154.202:8000/api/logout'), // Replace with your API URL
    );

    if (response.statusCode == 200) {
      // Logout successful, clear the user's session/token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to SignUp page
      Navigator.pushReplacementNamed(context, '/signup');
    } else {
      // Logout failed, display a pop-up dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Failed'),
            content: Text('Failed to logout. Please try again.',
              style: TextStyle(fontSize: 10),),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  DateTime _selectedDate = DateTime.now();
  final AccountController _accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      drawer: Drawer(
        backgroundColor: Colors.white60,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(

              accountName: Text('MIDLANDS STATE UNIVERSITY'),
              accountEmail: FutureBuilder<String?>(
                future: getUserEmail(),
                builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final email = snapshot.data ?? 'Anonymous';
                    return Text(email);
                  }
                },
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/midlands.jpeg'), // Replace with user's profile picture

              ),
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('Create a Post'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateBlogPostScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.newspaper_sharp),
              title: Text('Vacancies'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlogPostsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt),
              title: Text('Alumni List'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserListScreen()));
              },

            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                _showHelpDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileDetails()));

              },
            ),

            // ListTile(
            //   leading: const Icon(Icons.verified_user),
            //   title: Text('Tests'),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => Testfile()));
            //
            //   },
            // ),


          ],
        ),
      ),

      body: Column(
        children: [
          _addAccountBar(),

          // _addDateBar(),
          const SizedBox(height: 6),
          // _showAccounts(),
        ],
      ),
    );
  }


  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(
          Icons.menu, // Use the menu icon for the drawer
          size: 24,
          color: Colors.blue, // Set the color to blue
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            notifyHelper.cancelAllNotification();
            // _accountController.deleteAllAccounts();
          },
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/midlands.jpeg'),
          radius: 18,
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Scaffold _scaffoldWithDrawer() {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addAccountBar(),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  _addAccountBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle),
              Text('Your Account', style: headingStyle),
            ],
          ),
          MyButton(
            label: '+ Update Account',
            onTap: () async {
              await Get.to(() => const AddAccountPage());
              _accountController.getAccounts();
            },
          ),
        ],
      ),
    );
  }
}

