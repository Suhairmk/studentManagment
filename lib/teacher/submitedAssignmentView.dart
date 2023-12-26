import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';
import 'package:student_management/teacher/ViewFile.dart';

class SubmitedAssignmentsView extends StatefulWidget {
  const SubmitedAssignmentsView(
      {super.key,
      required this.assgnId,
      required this.subject,
      required this.year});
  final year;
  final subject;
  final assgnId;
  @override
  State<SubmitedAssignmentsView> createState() =>
      _SubmitedAssignmentsViewState();
}

class _SubmitedAssignmentsViewState extends State<SubmitedAssignmentsView> {
  List<AssignmentSubm> assignments = [];
  //retreve from firebase
  final CollectionReference assignmentsCollection =
      FirebaseFirestore.instance.collection('submitted_assignments');

  Future<List<AssignmentSubm>> getAssignmentsByYearAndSubject(
    String year,
    String subject,
    String assgnId,
  ) async {
    try {
      QuerySnapshot querySnapshot = await assignmentsCollection
          .where('year', isEqualTo: year)
          .where('subject', isEqualTo: subject)
          .where('assignmentId', isEqualTo: assgnId)
          .get();

      List<AssignmentSubm> assignment = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return AssignmentSubm(
          assignmentId: data['assignmentId'] ?? '',
          studentId: data['studentId'] ?? '',
          name: data['name'] ?? '',
          submissionDate: data['submissionDate'] ?? '',
          subject: data['subject'] ?? '',
          year: data['year'] ?? '',
          imgUrl: data['imgUrl'] ?? '',
        );
      }).toList();
      print('inlength${assignment.length}');
      return assignment;
    } catch (e) {
      print('Error getting assignments: $e');
      return [];
    }
  }

  Future<void> fetchData() async {
    assignments = await getAssignmentsByYearAndSubject(
        widget.year, widget.subject, widget.assgnId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Submitted Assignments'),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<void>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display the assignments
                      return ListView.builder(
                        itemCount: assignments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              children: [
                                Text(assignments[index].name),
                                Text(assignments[index].assignmentId),
                                Text(assignments[index].subject),
                                Text(assignments[index].submissionDate),

                                if(assignments[index].imgUrl.toLowerCase().contains('jpg')||
                                assignments[index].imgUrl.toLowerCase().contains('png')||
                                assignments[index].imgUrl.toLowerCase().contains('jpeg')||
                                assignments[index].imgUrl.toLowerCase().contains('gif')
                                 )
                                Image.network(assignments[index].imgUrl,height: 50,width:200 ,),
                                 if(assignments[index].imgUrl.toLowerCase().contains('pdf'))
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFView(
                                              filePath:
                                                  assignments[index].imgUrl
                                              // Add more options as needed
                                              ),
                                        ),
                                      );
                                    },
                                    child: Text('View File')),

                                // Display PDF if it's a PDF file

                                // Add more details as needed
                              ],
                            ),
                          );
                        },
                      );
                    }
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
