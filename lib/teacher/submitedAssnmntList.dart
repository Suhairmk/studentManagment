import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';
import 'package:student_management/teacher/submitedAssignmentView.dart';

class SubmitedAssinmntList extends StatefulWidget {
  const SubmitedAssinmntList({super.key});

  @override
  State<SubmitedAssinmntList> createState() => _SubmitedAssinmntListState();
}

class _SubmitedAssinmntListState extends State<SubmitedAssinmntList> {
  String selectedYear = '1st year';
  String selectedSubject = 'Subject';
  List<AssignmentQstn> assignments = [];
  // Example: Retrieving assignments
  Future<List<AssignmentQstn>> getAssignmentsForSubjectAndYear() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('assignments')
          .where('year', isEqualTo: selectedYear)
          .where('subject', isEqualTo: selectedSubject)
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
      print('year:$selectedYear.sub:"$selectedSubject');
      print(assignment.length);

      return assignment;
    } catch (e) {
      print('Error getting assignments: $e');
      return []; // Return an empty list in case of an error
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
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              // dropdown for year
              DropdownButton<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    selectedSubject = 'Subject';
                    getAssignments();
                  });
                },
                items: <String>['1st year', '2nd year', '3rd year']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
              // dropdown for subject
              DropdownButton<String>(
                value: selectedSubject,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubject = newValue!;
                    getAssignments();
                  });
                },
                items: getSubjectList(selectedYear, provider)
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
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
                                          SubmitedAssignmentsView(year: selectedYear,subject: selectedSubject,assgnId:assignments[index].title,)));
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
