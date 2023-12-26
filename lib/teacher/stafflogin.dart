import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/admin/adminpanel.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';
import 'package:student_management/teacher/teacherPanel.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({Key? key}) : super(key: key);

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //initialize firebase auth

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> loginWithEmailPass(provider) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('staff').doc(uid).get();

      Teacher teacher =
          Teacher.fromMap(userSnapshot.data() as Map<String, dynamic>);
      String role = teacher.role;

      try {
        if (role == 'Admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const AdminPanel()));
        } else if (role == 'Teacher') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const TeacherPanel()));
        }
      } catch (e) {
        print('Error navigating: $e');
      }

      print(role);
    } catch (e) {
      provider.showSnackbar(context, 'Login Failed');
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Staff Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black))),
                ),
                const SizedBox(height: 10),
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
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black))),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // Add your forgot password logic here
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      primary: Colors.grey[800],
                    ),
                    child: provider.isLoading
                        ? Container(
                            height: 30,
                            width: 20,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ))
                        : const Text(
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
