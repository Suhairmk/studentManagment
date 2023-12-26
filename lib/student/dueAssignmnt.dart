import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/student/assignSubmiss.dart';

class DueAssignments extends StatefulWidget {
  const DueAssignments({super.key, required this.subject, required this.year,required this.stdId,required this.stdName});
  final subject;
  final year;
  final stdName;
  final stdId;
  @override
  State<DueAssignments> createState() => _DueAssignmentsState();
}

class _DueAssignmentsState extends State<DueAssignments> {
  List<AssignmentQstn> assignments = [];
  // Example: Retrieving assignments
  Future<List<AssignmentQstn>> getAssignmentsForSubjectAndYear() async {
    String year = widget.year;
    String subject = widget.subject;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('assignments')
          .where('year', isEqualTo: year)
          .where('subject', isEqualTo: subject)
          .get();

      List<AssignmentQstn> assignment = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return AssignmentQstn(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          dueDate: data['dueDate'] ?? '',
          subject: data['subject'] ?? '',
          year: data['year'] ?? '',
        );
      }).toList();
      print('year:$year.sub:"$subject');
      print(assignment.length);

      return assignment;
    } catch (e) {
      print('Error getting assignments: $e');
      return []; // Return an empty list in case of an error
    }
  }

  @override
  void initState() {
    super.initState();
    getAssignments();
  }

  Future<void> getAssignments() async {
    assignments = await getAssignmentsForSubjectAndYear();
    setState(() {}); // Trigger a rebuild after fetching assignments
  }

  @override
  Widget build(BuildContext context) {
    String subject = widget.subject;
    String year = widget.year;

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text(
            'Assignments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: assignments.length == 0
                ? Center(
                    child: Text(
                      'No Assignments',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45),
                    ),
                  )
                : ListView.builder(
                    itemCount: assignments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AssignmentSubmission(
                                            index: index,
                                            year: year,
                                            subject: subject,
                                            assgnId: assignments[index].title,
                                            stdId: widget.stdId,
                                            stdName: widget.stdName,
                                          )));
                            },
                            title: Text(assignments[index].title),
                            trailing: Text(assignments[index].dueDate),
                          ),
                        ],
                      );
                    },
                  ),
          )
        ],
      )),
    );
  }
}
