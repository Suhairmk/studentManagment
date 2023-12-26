import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';

class AllRegistration extends StatefulWidget {
  @override
  _AllRegistrationState createState() => _AllRegistrationState();
}

class _AllRegistrationState extends State<AllRegistration> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController roleController = TextEditingController();
  final List<String> roles = ['Admin', 'Teacher']; // Dropdown options
  String selectedRole = 'Teacher';
  final _formKey = GlobalKey<FormState>();

  //registration
  Future<void> registerUser(String id, String email, String name,
      String password, String role, provider) async {
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

      Teacher teacher = Teacher(id: id, name: name, email: email, role: role);
      // Store user role in Firestore
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(uid)
          .set(teacher.toJson());
      provider.showSnackbar(
          context, 'Staff Registerd SuccessFully', Colors.green);
      idController.clear();
      nameController.clear();
      emailController.clear();
      passwordController.clear();
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
                Text('Staff Registration'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter id';
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
                  value: selectedRole,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value.toString();
                    });
                  },
                  items: roles.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    print("role is=$selectedRole");
                    // Handle registration logic here
                    if (_formKey.currentState!.validate()) {
                      registerUser(
                          idController.text,
                          emailController.text,
                          nameController.text,
                          passwordController.text,
                          selectedRole,
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
