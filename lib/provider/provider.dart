import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_management/dashboard.dart';

class MyProvider extends ChangeNotifier {
  List<String> firstYearSubjects = ['Subject', 'English', 'Maths', 'language'];
  List<String> secondYearSubjects = [
    'Subject',
    'C++',
    'DBMS',
    'JAVA',
  ];
  List<String> thirdYearSubjects = ['Subject', 'project', 'seminar', 'Python'];

  Future<void> logout(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashBoard()));
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  void showSnackbar(BuildContext context, String message,Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style:TextStyle(color: color),),
        duration: Duration(
            seconds:
                2), // Set the duration for how long the snackbar should be displayed
      ),
    );
  }

  bool isLoading = false;
  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

   void startLoading() {
    isLoading = true;
    notifyListeners(); // Notify listeners to trigger a rebuild

    // Simulate a time-consuming operation with Future.delayed
    Future.delayed(Duration(seconds: 3), () {
      isLoading = false; // Update isLoading
      notifyListeners(); // Notify listeners again after the loading is done
    });
  }
}
