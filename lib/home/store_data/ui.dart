import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:msualumini/home/store_data/button.dart';
import 'package:msualumini/home/store_data/theme.dart';
import 'account_model.dart';
import 'input.dart';

import 'package:http/http.dart' as http;



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



  @override
  void initState() {
    super.initState();

    _phone = '';
    _areaofwork = '';
    _email = '';
    // _graduationclass = '';
    _empstatus = employment[0]; // Initialize with a default value
    _gender = genderList[0]; // Initialize with a default value
  }

  DateTime _selected_date = DateTime.now();
  DateTime _graduation_date = DateTime.now();
  late String _gender;
  String? _selectedGender;
  late String _email;
  late String _fullname;
  late String _areaofwork;
  late String _selected_repeat = workList[0];
  late String? _employment_status= employment[0];
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
    String formattedDate = '${now.year}-${now.month}-${now.day} ${now
        .hour}:${now.minute}:${now.second}';

    Map<String, dynamic> userData = {
      'name': _fullnameController.text,
      'country': _countryController.text,
      'selected_date': formattedDate,
      'graduation_date': _graduation_date.toString(),
      'gender': _gender,
      'email': _emailController.text,
      'areaofwork': _areaofwork,
      'selected_repeat': _selected_repeat,
      'employment_status': _employment_status,
      'empstatus': _empstatus,
      'phone': _phone,
      // 'graduationclass': _graduationclass,
    };


    var apiUrl = 'http://172.105.154.202:8000/api/user-data';


    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
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
              ),
              InputField(
                fullname: 'Email',
                hint: 'Enter email here',
                controller: _emailController,
              ),
              InputField(
                fullname: 'Country',
                hint: 'Enter country here',
                controller: _countryController,
              ),

              InputField(
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

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Phone',
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


              Row(
                children: [
                  Expanded(
                    child:
                    InputField(
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
                      fullname: 'Working Status',
                      hint: _empstatus,
                      widget: Row(
                        children: [
                          DropdownButton(
                            dropdownColor: Colors.black54,
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
                            value: _employment_status, // Set the selected value here
                            onChanged: (String? newValue) {
                              setState(() {
                                _employment_status = newValue;
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
                fullname: 'Gender',
                hint: _gender,
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.black54,
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

              //Area of work
              InputField(
                fullname: 'Area of work',
                hint: _areaofwork,
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.black54,
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
                      iconSize: 30,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: subTitleStyle,
                      value: _selected_repeat , // Set the selected value here
                      onChanged: (String? newValue) {
                        setState(() {
                          _selected_repeat  = newValue!; // Update _selectedAreaOfWork
                          _areaofwork = newValue ?? workList[0]; // Update _areaofwork
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),



              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
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
      // backgroundColor: context.theme.backgroundColor,
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

  // _addAccountsToDb() async {
  //   try {
  //
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
  //     int value = await _accountController.addAccount(
  //       account: Account(
  //         fullname: _fullnameController.text,
  //         country: _countryController.text,
  //         isCompleted: 0,
  //         date: DateFormat.yMd().format(_selectedDate),
  //         gender: _gender,
  //         email :_emailController.text,
  //         areaofwork:_areaofwork ,
  //         empstatus:_empstatus ,
  //         phone: _phone,
  //          graduationclass: DateFormat.yMd().format(_GraduationDate),
  //
  //       ),
  //     );
  //     print('id value = $value');
  //   } catch (e) {
  //     print('Error = $e');
  //   }
  // }

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

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null)
      setState(() => _selected_date = _pickedDate);
    else
      print('It\'s null or something is wrong');
  }
  _getDetailsFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2040),
    );
    if (_pickedDate != null)
      setState(() => _graduation_date = _pickedDate);
    else
      print('It\'s null or something is wrong');
  }


}

_getDetailsFromUser (workStatus) async
{
}