// import 'package:firebase_database/firebase_database.dart';
//
// void saveDataToFirebase(String fullName) {
//   final DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
//
//   // Assuming you have a "users" node in your database
//   DatabaseReference userRef = databaseRef.child('users');
//
//   // Generate a unique key for the new user
//   String userId = userRef.push().key;
//
//   // Create a map containing the data you want to save
//   Map<String, dynamic> userData = {
//     'fullname': fullName,
//     // Add other fields as needed
//   };
//
//   // Save the data to the database using the unique key
//   userRef.child(userId).set(userData);
// }


import 'package:firebase_auth/firebase_auth.dart';

// Send OTP to user's email
Future<void> sendOTP(String email) async {
  try {
    await FirebaseAuth.instance.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://alumini-bc88d.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
        handleCodeInApp: true,
      ),
    );
  } catch (e) {
    // Handle errors
  }
}

// Verify OTP and sign in
Future<void> verifyOTP(String email, String otp) async {
  try {
    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailLink(
      email: email,
      emailLink: 'https://alumini-bc88d.firebaseapp.com/__/auth/action?mode=action&oobCode=code',
    );

    final User? user = userCredential.user;

    // You can store user data and set the user as authenticated here.
  } catch (e) {
    // Handle errors
  }
}
