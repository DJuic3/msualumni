import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msualumini/home/store_data/button.dart';
import 'package:msualumini/home/store_data/search.dart';
import 'package:msualumini/home/store_data/size_config.dart';
import 'package:msualumini/home/store_data/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'account_model.dart';
import 'input.dart';
// import 'package:type_ahead/type_ahead.dart';
import 'package:http/http.dart' as http;


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



Future<void> storeUserData(UserData userData) async {
  final apiUrl = 'http://172.105.154.202:8000/api/user-data';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(userData.toJson()),
    );

    if (response.statusCode == 200) {
      // Data stored successfully
      print('Data stored successfully');
    } else {
      // Handle errors
      print('Error storing data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Request data: ${jsonEncode(userData.toJson())}');
    }
  } catch (e) {
    // Handle exceptions
    print('Exception: $e');
  }
}

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({Key? key}) : super(key: key);

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  // final AccountController _accountController = Get.put(AccountController());
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isAccountUpdated = false;


  @override
  void initState() {
    super.initState();
    _phone = '';
    _email = '';
    _empstatus = employment[0]; // Initialize with a default value
    _gender = genderList[0];
    _areaofwork = '';// Initialize with a default value
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Update Account', style: headingStyle),

                InputField(
                  fullname: 'Full Name',
                  hint: 'Enter full name here',
                  controller: _fullnameController,
                  enabled: !isAccountUpdated,
                ),
                InputField(
                  fullname: 'Email',
                  hint: 'Enter email here',
                  controller: _emailController,
                  enabled: !isAccountUpdated,
                ),
                InputField(
                  fullname: 'Country',
                  hint: 'Enter country here',
                  controller: _countryController,
                  enabled: !isAccountUpdated,
                ),

                InputField(
                  enabled: !isAccountUpdated,
                  fullname: 'Date of birth',
                  hint: DateFormat.yMd().format(_selected_date),
                  widget: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [SizedBox(height: 10),

                    Text(
                      'Phone Number',
                      style: subTitleStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),

                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 14),
                      margin: const EdgeInsets.only(top: 8),
                      width: SizeConfig.screenWidth,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter phone number',
                        ),
                        onChanged: (value) {
                          _phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ),
                  ],
                ),



                Row(
                  children: [
                    Expanded(
                      child:
                      InputField(
                        enabled: !isAccountUpdated,
                        fullname: 'Graduation Year',
                        hint: DateFormat.yMd().format(_graduation_date),
                        widget: IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _getDetailsFromUser();
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                      InputField(
                        enabled: !isAccountUpdated,
                        fullname: 'Working Status',
                        hint: _empstatus,
                        widget: Row(
                          children: [
                            DropdownButton(
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              items: employment.map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      // color: Colors.black,
                                    ),
                                  ),
                                ),
                              ).toList(),
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                              iconSize: 32,
                              elevation: 4,
                              underline: Container(height: 0),
                              style: subTitleStyle,
                              value: _selectedEmploymentStatus, // Set the selected value here
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEmploymentStatus = newValue;
                                  _empstatus= newValue ?? employment[0]; // Update the selected value
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                          ],
                        ),


                      ),
                    ),
                  ],
                ),

                InputField(
                  enabled: !isAccountUpdated,
                  fullname: 'Gender',
                  hint: _gender,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        items: genderList.map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              '$value',
                              style: const TextStyle(
                                // color: Colors.black,
                              ),
                            ),
                          ),
                        ).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        value: _selectedGender, // Set the selected value here
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue; // Update the selected value
                            _gender = newValue ?? genderList[0]; // Update _gender
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),

                // Area of work
                InputField(
                  enabled: !isAccountUpdated,
                  fullname: 'Area of work',
                  hint: _areaofwork,
                  widget: Row(
                    children: [
                      DropdownButton(
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        items: workList.map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                // color: Colors.black,
                              ),
                            ),
                          ),
                        ).toList(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        iconSize: 5,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        value: _repeat , // Set the selected value here
                        onChanged: (String? newValue) {
                          setState(() {
                            _repeat  = newValue!; // Update _selectedAreaOfWork
                            _areaofwork = newValue ?? workList[0]; // Update _areaofwork
                          });
                        },
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),

                // InputField(
                //   enabled: !isAccountUpdated,
                //   fullname: 'Area of work',
                //   hint: _areaofwork,
                //   widget: Autocomplete<String>(
                //     optionsBuilder: (TextEditingValue textEditingValue) {
                //       return workList.where((String option) {
                //         return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                //       });
                //     },
                //     onSelected: (String value) {
                //       setState(() {
                //         _repeat = value;
                //         _areaofwork = value;
                //       });
                //     },
                //     fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                //       return TextFormField(
                //         controller: textEditingController,
                //         decoration: InputDecoration(
                //           labelText: 'Area of work',
                //           hintText: 'Type to search...',
                //         ),
                //       );
                //     },
                //     optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                //       return Align(
                //         alignment: Alignment.topLeft,
                //         child: Material(
                //           elevation: 4.0,
                //           child: SizedBox(
                //             height: 200.0,
                //             child: ListView.builder(
                //               padding: EdgeInsets.all(8.0),
                //               itemCount: options.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 final String option = options.elementAt(index);
                //                 return GestureDetector(
                //                   onTap: () {
                //                     onSelected(option);
                //                   },
                //                   child: ListTile(
                //                     title: Text(option),
                //                   ),
                //                 );
                //               },
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),


                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // _colorPalette(),
                    MyButton(
                      label: 'Accept',
                      onTap: () {

                        sendUserDataToAPI();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            )
        ),
      ),
    );

  }


  DateTime _selected_date = DateTime.now();
  DateTime _graduation_date = DateTime.now();
  late String _gender;
  String? _selectedGender;
  late String _email;
  late String _fullname;
  late String _areaofwork;
  late String _repeat = workList[0];
  late String? _selectedEmploymentStatus = employment[0];
  late String _empstatus;
  late String _phone;
  // late String _graduationclass;
  List<String> genderList = ['Male', 'Female'];
  List <String> employment = ['Employed','Unemployed','Searching', 'Freelancer' ];
  List<String> workList = ["Software Developer", "Nurse", "Teacher", "Accountant", "Electrician",
    "Graphic Designer", "Marketing Manager", "Dentist",
    "Project Manager", "Pharmacist", "Chef", "Police Officer", "Data Analyst",
    "Mechanical Engineer", "Lawyer", "Financial Analyst", "Architect", "Social Worker",
    "Librarian", "Doctor", "Construction Worker", "Veterinary Technician", "Photographer",
    "Farmer", "Physical Therapist", "Web Developer", "Admin Assistant", "IT Manager",
    "Occupational Therapist", "Real Estate Agent", "Dental Hygienist", "Bank Teller",
    "Event Planner", "Human Resources Manager", "Occupational Health and Safety Specialist",
    "Marketing Coordinator", "Bank Teller", "Councilor", "Influencer",
    "Risk Officer", "Activist", "Freelancer", "Content Creator",
    "Real Estate Agent", "Janitor", "Vendor", "House Decorator", "Flight Attendant",
    "Investment Banker", "Pharmaceutical Sales Representative","Other",
  ];
  String _searchTerm = "";
  int _selectedColor = 0;



  @override
  void dispose() {
    _fullnameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    super.dispose();
  }
// Function to send data to Laravel API
  void sendUserDataToAPI() async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';

    Map<String, dynamic> userData = {
      'name': _fullnameController.text,
      'country': _countryController.text,
      'selected_date': _selected_date.toString(),
      'graduation_date': _graduation_date.toString(),
      'gender': _gender,
      'email': _emailController.text,
      'areaofwork': _areaofwork,
      'repeat': _repeat,
      'employment_status': _selectedEmploymentStatus,
      'empstatus': _empstatus,
      'phone': _phone,
      // 'graduationclass': _graduationclass,
    };
    print(userData);

    // Get user token from SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    String? userToken = sharedPreferences.getString('userToken');

    if (userToken == null) {
      // Handle case where user token is not available (user not logged in)
      Fluttertoast.showToast(
        msg: 'User not logged in. Please log in and try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    var apiUrl = 'http://172.105.154.202:8000/api/user-data';

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json'// Include the user's access token
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      // Data sent successfully
      Fluttertoast.showToast(
        msg: 'Account Updated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      setState(() {
        isAccountUpdated = true;
      });
    } else {
      // Error sending data
      Fluttertoast.showToast(
        msg: 'Failed to Update Account. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print('Error sending data. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }







}

// _getDetailsFromUser (workStatus) async
// {
// }
  _getDetailsFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1700),
      lastDate: DateTime(2050),
    );
    if (_pickedDate != null)
      setState(() => _graduation_date = _pickedDate);
    else
      print('It\'s null or something is wrong');
  }

  void _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selected_date,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (_pickedDate != null)
      setState(() => _selected_date = _pickedDate);
    else
      print('It\'s null or something is wrong');
  }

  AppBar _appBar() {
    return AppBar(

      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),

      elevation: 0,
      backgroundColor: Colors.white,
      actions: const [

        CircleAvatar(
          backgroundImage: AssetImage('assets/images/midlands.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20),
      ],

    );
  }

  _validateDate() {
    FocusScope.of(context).unfocus();
    if (_fullnameController.text.isNotEmpty && _countryController.text.isNotEmpty) {
      ;
      Get.back();
    } else if (_fullnameController.text.isEmpty || _countryController.text.isEmpty) {
      Get.snackbar(
        'required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    } else
      print('############ SOMETHING BAD HAPPENED #################');
  }


  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: fullnameStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
                (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(Icons.done, size: 16, color: Colors.white)
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                      ? pinkClr
                      : orangeClr,
                  radius: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }



}