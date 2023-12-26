import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/admin/adminpanel.dart';
import 'package:student_management/dashboard.dart';
import 'package:student_management/firebase_options.dart';

import 'package:student_management/provider/provider.dart';
import 'package:student_management/student/stdHome.dart';
import 'package:student_management/teacher/teacherPanel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MyApp(user: user),
    ),
  );
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: determineInitialScreen(),
    );
  }

  Widget determineInitialScreen() {
    if (user != null) {
      return FutureBuilder<String?>(
        future: getUserRoleFromFirestore(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.black,), // Show loading indicator
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            print('Error: ${snapshot.error}');
            return DashBoard(); // Default screen if there's an error or null data
          } else {
            String userRole = snapshot.data!;

            print('User Role: $userRole');

            if (userRole == 'staff') {
              return TeacherPanel();
            } else if (userRole == '1st year' ||
                userRole == '2nd year' ||
                userRole == '3rd year') {
              return StdHome(year: userRole);
            } else if (userRole == 'admin') {
              return AdminPanel(); // Default screen if the role doesn't match
            }
          }
          return DashBoard();
        },
      );
    }

    // Default screen if user is not authenticated
    return DashBoard();
  }

  Future<String?> getUserRoleFromFirestore(String userId) async {
    try {
      List<String> collectionNames = [
        'staff',
        '1st year',
        '2nd year',
        '3rd year'
      ];

      for (String collectionName in collectionNames) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userId)
            .get();

        if (doc.exists) {
          // Assuming 'role' is the field storing the user role
          return collectionName;
        }
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }

    return null;
  }
}
