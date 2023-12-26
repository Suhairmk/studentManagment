import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:student_management/provider/provider.dart';
import 'package:student_management/student/NotificationsStd.dart';
import 'package:student_management/student/attReview.dart';
import 'package:student_management/student/dailyAtt.dart';
import 'package:student_management/student/dueAssignmnt.dart';

class StdHome extends StatefulWidget {
  const StdHome({
    super.key,
    required this.year,
  });
  final year;

  @override
  State<StdHome> createState() => _StdHomeState();
}

class _StdHomeState extends State<StdHome> {
  List<String> subject = [];
  String? stdName;
  String? stdEmail;
  String? stdId;

  Future<void> getDataFromFirestore() async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(widget.year)
          .doc(user!.uid)
          .get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      setState(() {
        print('hello');
        stdName = userData!['name'];
        stdEmail = userData['email'];
        stdId = userData['id'];
      });
    } catch (e) {
      print('error');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    String year = widget.year;
    var provider = Provider.of<MyProvider>(context);

    if (year == '1st year') {
      subject = provider.firstYearSubjects;
    } else if (year == '2nd year') {
      subject = provider.secondYearSubjects;
    } else if (year == '3rd year') {
      subject = provider.thirdYearSubjects;
    } else {
      // Handle the case when selectedYear doesn't match any of the above conditions
      // You can provide a default value or display an error message, for example.
    }
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Subjects',
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewNotificationStudent()));
                    },
                    icon: Icon(Icons.notifications_active_outlined)),
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
                    color: Colors.blue,
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
                        // Text(stdId??''),
                        // Text(stdName!),
                        // Text(widget.year),
                      ],
                    ),
                  ),
                ),
                // Attendance button
                ListTile(
                  leading: Icon(
                    Icons.add_card_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Attentence Review',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceReviewScreen(
                                studentId: stdId!,
                                year: year))); // Close the drawer
                  },
                ),
                // Add with icons button
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
              child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: subject.length,
                  itemBuilder: (BuildContext context, int index) {
                    String currentSubject = subject[index];

                    if (currentSubject == 'Subject') {
                      // Skip this item
                      return SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DueAssignments(
                                        subject: subject[index],
                                        year: year,
                                        stdId: stdId,
                                        stdName: stdName,
                                      ))),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Column(
                                children: [
                                  Text(currentSubject),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ))),
    );
  }
}
