import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';

class AddAttendance extends StatefulWidget {
  @override
  _AddAttendanceState createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  //initialize
  String selectedYear = '1st year';
  String selectedHour = 'Hour';
  String selectedSubject = 'Subject';
  String? selectedDay = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int totalStudents = 0;
  int presentCount = 0;
  List<int> presentStudentList = [];
  late List<bool> isPresentList; // Use 'late' to delay initialization

  //for calender
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDay = DateFormat('yyyy-MM-dd').format(pickedDate!);
      });
      print('Selected Date: $selectedDay');
    }
  }

  // store in firebase

  void addAttentencetofirestore(provider) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the new collection
      CollectionReference newCollection =
          firestore.collection('studentAttentence');

      // Retrieve the teacherId
      String? tcrId = await getTeacherId();

      // Ensure that the teacherId is not null before proceeding
      if (tcrId == null) {
        print('Teacher ID is null.');
        return;
      }

      // Create a StudentAttentence object
      StudentAttentence attentence = StudentAttentence(
        teacherId: tcrId,
        date: selectedDay!,
        year: selectedYear,
        hour: selectedHour,
        subject: selectedSubject,
        studentList: presentStudentList,
      );

      // Convert the StudentAttentence object to a Map using toJson
      Map<String, dynamic> data = attentence.toJson();

      // Add a document to the new collection (optional, you can skip this step)
      await newCollection.add(data);
      provider.showSnackbar(context, 'Attentence Added Successfully');

      print('Document created successfully.');
    } catch (e) {
      print('Error creating new collection: $e');
    }
  }

  //get teacher id
  Future<String?> getTeacherId() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        // Use the user ID to query the 'staff' collection
        DocumentSnapshot staffSnapshot = await FirebaseFirestore.instance
            .collection('staff')
            .doc(user.uid)
            .get();

        // Check if the document exists
        if (staffSnapshot.exists) {
          // 'teacherId' is assumed to be the field in the 'staff' collection
          return staffSnapshot['id'];
        } else {
          // Handle the case where the document does not exist
          return null;
        }
      } else {
        // Handle the case where the user is not authenticated
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving teacher ID: $e');
      return null;
    }
  }

  //list subject based on selected year
  List<String> getSubjectList(String selectedYear, provider) {
    if (selectedYear == '1st year') {
      return provider.firstYearSubjects;
    } else if (selectedYear == '2nd year') {
      return provider.secondYearSubjects;
    } else if (selectedYear == '3rd year') {
      return provider.thirdYearSubjects;
    } else {
      // Handle the case when selectedYear doesn't match any of the above conditions
      // You can provide a default value or an empty list, for example.
      return [];
    }
  }

  void _resetCheckboxes() {
    setState(() {
      isPresentList = List.generate(isPresentList.length, (index) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize isPresentList when the widget is created
    isPresentList = List.filled(totalStudents, false);
  }

  @override
  Widget build(BuildContext context) {
    int abs = totalStudents - presentCount;
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Add Attendance')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //calender
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Row(
                      children: [
                        Text(
                          selectedDay.toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(Icons.arrow_drop_down),
                        )
                      ],
                    ),
                  ),
                  //dropdown
                  DropdownButton<String>(
                    value: selectedYear,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                        presentCount = 0;
                        abs = 0;
                        presentStudentList.clear();
                        selectedSubject = 'Subject';
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
                  // Add more dropdown buttons for class and hour selection
                  
                ],
              ),
              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                DropdownButton<String>(
                    value: selectedHour,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHour = newValue!;
                      });
                    },
                    items: <String>[
                      'Hour',
                      '09.00--10.00',
                      '10.00--11.00',
                      '11.10--12.00',
                      '12.00--01.00',
                      '02.00--03.00',
                      '04.00--05.00'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  //subject dropdown
                  DropdownButton<String>(
                    value: selectedSubject,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubject = newValue!;
                      });
                    },
                    items: getSubjectList(selectedYear, provider)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              ],),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(selectedYear)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    totalStudents = documents.length;

                    // Check if isPresentList needs resizing
                    if (isPresentList.length != totalStudents) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {
                          isPresentList = List.filled(totalStudents, false);
                        });
                      });
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              Student student =
                                  Student.fromSnapshot(documents[index]);
                              return ListTile(
                                title: Text(student.name),
                                subtitle: Text(student.email),
                                trailing: Checkbox(
                                  value: isPresentList[index],
                                  onChanged: (bool? value) {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback(
                                      (_) {
                                        setState(() {
                                          isPresentList[index] = value ?? false;
                                          if (value == true) {
                                            presentCount++;
                                            presentStudentList
                                                .add(int.parse(student.id));
                                          } else {
                                            presentCount--;
                                            presentStudentList
                                                .remove(int.parse(student.id));
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Text('Present: $presentCount'),
                        Text('Absent: $abs'),
                        Text('Total Students: $totalStudents'),
                        ElevatedButton(
                          onPressed: () async {
                            String? Id = await getTeacherId();
                            // Implement your logic to submit attendance
                            addAttentencetofirestore(provider);
                            _resetCheckboxes();
                            print(
                                'day:$selectedDay.sub:$selectedSubject.hour:$selectedHour.year:$selectedYear.list:$presentStudentList.id:$Id');
                          },
                          child: Text('Submit Attendance'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
