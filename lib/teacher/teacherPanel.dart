import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:student_management/provider/provider.dart';
import 'package:student_management/teacher/addAttend.dart';
import 'package:student_management/teacher/assignTeacher.dart';
import 'package:student_management/teacher/notificationsTcr.dart';
import 'package:student_management/teacher/studentReg.dart';
import 'package:student_management/teacher/submitedAssignmentView.dart';
import 'package:student_management/teacher/submitedAssnmntList.dart';

class TeacherPanel extends StatefulWidget {
  const TeacherPanel({super.key});

  @override
  State<TeacherPanel> createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  String selectedYear = '1st year';
  List<String> subject = [];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    if (selectedYear == '1st year') {
      subject = provider.firstYearSubjects;
    } else if (selectedYear == '2nd year') {
      subject = provider.secondYearSubjects;
    } else if (selectedYear == '3rd year') {
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
            'Activities',
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
                            builder: (context) => ViewNotificationTeacher()));
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
                  child: Text(
                    'Activities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
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
                  'Attendance',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddAttendance())); // Close the drawer
                },
              ),
              // Add with icons button
              ListTile(
                leading: Icon(
                  Icons.people_sharp,
                  color: Colors.white,
                ),
                title:
                    Text('Add Students', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StudentRegistration())); // Close the drawer
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.assignment,
                  color: Colors.white,
                ),
                title: Text('View Assignments ',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SubmitedAssinmntList())); // Close the drawer
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                DropdownButton<String>(
                  hint: Text('Select Year'),
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue!;
                    });
                  },
                  items: <String>['1st year', '2nd year', '3rd year']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
                                    builder: (context) => AssignmentTeacher())),
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
            ),
          ),
        ),
      ),
    );
  }
}
