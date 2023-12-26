import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';

class StudentRegistration extends StatefulWidget {
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController roleController = TextEditingController();
  final List<String> year = [
    '1st year',
    '2nd year',
    '3rd year',
  ]; // Dropdown options
  String selectedYear = '1st year';
  final _formKey = GlobalKey<FormState>();

  //registration
  Future<void> registerUser(String id, String email, String name,
      String password, String year, provider) async {
    try {
      // Validate if id is numeric
      if (!RegExp(r'^[0-9]+$').hasMatch(id)) {
        // Show an error or handle the invalid id case
        print('Invalid ID');
        return;
      }

      // Create user in Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user role in Firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Determine the subcollection based on the user's year
      String subcollection;
      if (year == '1st year') {
        subcollection = '1st year';
      } else if (year == '2nd year') {
        subcollection = '2nd year';
      } else if (year == '3rd year') {
        subcollection = '3rd year';
      } else {
        // Handle other cases or show an error
        print('Invalid year');
        return;
      }
      Student student = Student(id: id, name: name, email: email, year: year);
      // Store user data in the appropriate subcollection
      await FirebaseFirestore.instance
          .collection(subcollection)
          .doc(uid)
          .set(student.toJson());
      provider.showSnackbar(
          context, 'Student Registered SuccessFully', Colors.green);
    } catch (e) {
      provider.showSnackbar(context, 'Invalid Datas', Colors.red);
      print('Error registering user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Student Registration'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Id';
                    }
                    return null; // Return null if the input is valid
                  },
                  controller: idController,
                  keyboardType:
                      TextInputType.number, // Set the keyboard type to numeric
                  decoration: InputDecoration(
                    labelText: 'Id',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null; // Return null if the input is valid
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
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
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null; // Return null if the input is valid
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: selectedYear,
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value.toString();
                    });
                  },
                  items: year.map((yr) {
                    return DropdownMenuItem(
                      value: yr,
                      child: Text(yr),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle registration logic here
                    if (_formKey.currentState!.validate()) {
                      registerUser(
                          idController.text,
                          emailController.text,
                          nameController.text,
                          passwordController.text,
                          selectedYear,
                          provider);
                    }
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
