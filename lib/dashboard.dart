import 'package:flutter/material.dart';
import 'package:student_management/teacher/stafflogin.dart';
import 'package:student_management/student/studentLogin.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoginContainer('Student Login',StudentLogin()),
              _buildLoginContainer('Staff Login',StaffLogin()),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContainer(String text,Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => screen));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.all(30),
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
