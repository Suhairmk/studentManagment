import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student_management/admin/adNotification.dart';
import 'package:student_management/admin/allRegistration.dart';
import 'package:student_management/admin/staffList.dart';
import 'package:student_management/admin/studnList.dart';
import 'package:student_management/models/models.dart';

import 'package:student_management/provider/provider.dart';



class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  late List<Teacher> tchr = [];
  int? firstyear;
  int? secondyear;
  int? thirdyear;

  @override
  void initState() {
    getTeachersDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Admin',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.person_outline)),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              // Drawer header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 54, 11, 128),
                ),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        'Activities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Attendance button
              ListTile(
                leading: Icon(
                  Icons.add_card_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Add Staff',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AllRegistration())); // Close the drawer
                },
              ),
              // Add with icons button
              ListTile(
                leading: Icon(
                  Icons.announcement,
                  color: Colors.white,
                ),
                title:
                    Text('Announcement', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddNotification())); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                title: Text('Log Out', style: TextStyle(color: Colors.white)),
                onTap: () {
                  provider.logout(context); // Close the drawer
                 
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StaffList(teachersList: tchr))),
                  child: Container(
                    width: MediaQuery.of(context).size.height - 60,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Staff Count  '),
                        Text(
                          tchr.length.toString(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.height - 60,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildYear(context, 'First Year ', firstyear),
                      buildYear(context, 'Second Year ', secondyear),
                      buildYear(context, 'Third Year ', thirdyear)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildYear(BuildContext context, text, count) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => StudentsList(year: text))),
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          Text(
            count.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      )),
    );
  }

  Future<void> getTeachersDetails() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('staff').get();
      QuerySnapshot firstyear1 = await firestore.collection('1st year').get();
      QuerySnapshot secondyear1 = await firestore.collection('2nd year').get();
      QuerySnapshot thirdyear1 = await firestore.collection('3rd year').get();

      List<Teacher> teacher = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Teacher(
            id: data['id'] ?? '',
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            role: data['role'] ?? '');
      }).toList();

      print(teacher.length);
      setState(() {
        tchr = teacher;
        firstyear = firstyear1.docs.length;
        secondyear = secondyear1.docs.length;
        thirdyear = thirdyear1.docs.length;
      });
    } catch (e) {
      print('Error getting teachersList: $e');
      // Return an empty list in case of an error
    }
  }
}
