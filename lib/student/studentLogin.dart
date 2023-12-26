import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';

import 'package:student_management/provider/provider.dart';
import 'package:student_management/student/stdHome.dart';
import 'package:student_management/teacher/addAttend.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? stdName;
  String? stdEmail;
  String? stdyear;
  String? stdId;
  final _formKey = GlobalKey<FormState>();
  //initialize firebase auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // String? uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> loginWithEmailPass(provider) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // Determine the student's year from the appropriate subcollection
      String year = await getStudentYear(uid);

      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection(year).doc(uid).get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      stdName = userData!['name'];
      stdEmail = userData['email'];
      stdId = userData['id'];
      stdyear = year;

      // Student student = Student(id: stdId!, name: stdName!, email: stdEmail!, year: year);

      // Print student details (for testing)
      print('ID: $stdId, Name: $stdName, Year: $stdEmail');

      // Navigate based on the student's year
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StdHome(year: year)),
      );
    } catch (e) {
      provider.showSnackbar(context, 'Failed to Sign in');
      emailController.clear();
      passwordController.clear;

      print('Failed to sign in: $e');
    }
  }

  Future<String> getStudentYear(String uid) async {
    try {
      // Check each subcollection for the student's ID
      List<String> subcollections = ['1st year', '2nd year', '3rd year'];

      for (String subcollection in subcollections) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection(subcollection)
            .doc(uid)
            .get();

        if (snapshot.exists) {
          // If the document exists in the subcollection, return the subcollection as the year
          return subcollection;
        }
      }

      // If the student is not found in any subcollection, return an empty string or handle the case as needed
      return '';
    } catch (e) {
      print('Error getting student year: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Student Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    // Email validation using a regular expression
                    if (!RegExp(
                            r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null; // Return null if the input is valid
                  },
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  controller: emailController,
                  decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(borderSide:BorderSide(color: Colors.amber)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black))),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null; // Return null if the input is valid
                  },
                  cursorColor: Colors.black,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.black))),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Add your forgot password logic here
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: screenWidth - 36,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Add your login logic here
                        provider.startLoading();
                        loginWithEmailPass(provider);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      primary: Colors.grey[800],
                    ),
                    child: provider.isLoading
                        ? Container(
                            height: 30,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ))
                        : Text(
                            'Submit',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
