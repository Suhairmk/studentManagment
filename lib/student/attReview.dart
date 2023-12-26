import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/provider/provider.dart';
import 'package:student_management/student/dailyAtt.dart';

class AttendanceReviewScreen extends StatefulWidget {
  final String studentId;
  final String year;

  const AttendanceReviewScreen(
      {Key? key, required this.studentId, required this.year})
      : super(key: key);

  @override
  _AttendanceReviewScreenState createState() => _AttendanceReviewScreenState();
}

class _AttendanceReviewScreenState extends State<AttendanceReviewScreen> {
  late int totalAttendanceEntries = 0;
  late int presentStdCount = 0;
  late double attendancePercentage = 0.00;
  // late int subjectWiseTotalAttendance = 0;
  // late int subjectWisepresentStdCount = 0;
  // late double subjectWisePercentage = 0.00;
  late Map<String, Map<String, dynamic>> subjectAttendanceData;

  @override
  void initState() {
     var provider = Provider.of<MyProvider>(context,listen: false);
    super.initState();
     fetchData();
    fetchAttendanceDetails(provider);

     
   
  }

  List<String> subjects = [];
//total attentence
  Future<void> fetchData() async {
    try {
      // Fetch attendance data based on student ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('studentAttentence')
          .where('year', isEqualTo: widget.year)
          .get();

      int presentCount = 0;

      // Iterate through each attendance entry
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Extract the student list from the document
        List<int> studentList = List<int>.from(doc['studentList']);

        print('Student ID from authenticated user: ${widget.studentId}');
        print('Student List in Firestore: $studentList');

        if (studentList.contains(int.parse(widget.studentId))) {
          presentCount++;
        }
      }

      setState(() {
        totalAttendanceEntries = querySnapshot.docs.length;

        presentStdCount = presentCount;

        attendancePercentage =
            (presentStdCount / totalAttendanceEntries) * 100.0;
      });
    } catch (e) {
      print('Error fetching subjectwiseAttendance data: $e');
    }
  }

  //subjectwise
  Future<void> fetchAttendanceDetails(provider) async {
 if (widget.year == '1st year') {
      subjects = provider.firstYearSubjects;
    } else if (widget.year == '2nd year') {
      subjects = provider.secondYearSubjects;
    } else if (widget.year == '3rd year') {
      subjects = provider.thirdYearSubjects;
    }

    try {
      subjectAttendanceData = {};
      print(subjects.length);

      // Fetch attendance data for each local subject
      for (String subject in subjects) {
       
        await subjectWise(subject);
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  Future<void> subjectWise(String sub) async {
    try {
      // Fetch attendance data based on student ID, year, and subject
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('studentAttentence')
          .where('year', isEqualTo: widget.year)
          .where('subject', isEqualTo: sub)
          .get();

      int presentCount = 0;

      // Iterate through each attendance entry
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Extract the student list from the document
        List<int> studentList = List<int>.from(doc['studentList']);

        // Check if the student is marked as present
        if (studentList.contains(int.parse(widget.studentId))) {
          presentCount++;
         
        }
      }

      setState(() {
        // Update attendance data for the subject
        subjectAttendanceData[sub] = {
          'totalAttendance': querySnapshot.docs.length,
          'presentCount': presentCount,
          'attendancePercentage':
              (presentCount / querySnapshot.docs.length) * 100.0,
        };
      });
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
   
   

    // Check if variables are null before using them
    if (totalAttendanceEntries == null || presentStdCount == null) {
      return CircularProgressIndicator(); // or return an empty widget, depending on your use case
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Review'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Total Attendance Entries: $totalAttendanceEntries'),
          Text('Present Count: $presentStdCount'),
          Text(
              'Attendance Percentage: ${attendancePercentage?.toStringAsFixed(2)}%'),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                String subject = subjects[index];
                Map<String, dynamic> attendanceData =
                    subjectAttendanceData[subject] ?? {};

                     if (subject == 'Subject') {
                    // Skip this item
                    return SizedBox.shrink();
                  }
                return Card(
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DailyAttendanceScreen(currentUserId: widget.studentId,year:widget.year ,subject:subject ,))),
                    title: Text(subject),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Total Attendance: ${attendanceData['totalAttendance'] ?? 0}'),
                        Text(
                            'Present Count: ${attendanceData['presentCount'] ?? 0}'),
                        Text(
                            'Attendance Percentage: ${attendanceData['attendancePercentage']?.toStringAsFixed(2) ?? '0.00'}%'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
