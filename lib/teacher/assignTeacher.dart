import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/provider/provider.dart';

class AssignmentTeacher extends StatefulWidget {
  const AssignmentTeacher({super.key});

  @override
  State<AssignmentTeacher> createState() => _AssignmentTeacherState();
}

class _AssignmentTeacherState extends State<AssignmentTeacher> {
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  String selectedYear = '1st year';
  String selectedSubject = 'Subject';
  // When a teacher assigns an assignment
  Future<void> assignAssignment(String title, String description,
      String dueDate, String subject, String year, provider) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference assignmentsCollection =
          firestore.collection('assignments');

      // Add assignment document
      await assignmentsCollection.add({
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'subject': subject,
        'year': year,
      });
      provider.showSnackbar(context, 'Assignment Assigned Successfully');
      titleController.clear();
      discriptionController.clear();
      dueDateController.clear();
      print('Assignment assigned successfully.');
    } catch (e) {
       provider.showSnackbar(context, 'Error',Colors.red);
      print('Error assigning assignment: $e');
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
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Assign Assignment'),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                //dropdown
                DropdownButton<String>(
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue!;
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
              ],
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
                label: Text('Title'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: discriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Discription',
                label: Text('Discription'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.datetime,
              controller: dueDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Due Date',
                label: Text('Due Date'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  assignAssignment(
                      titleController.text,
                      discriptionController.text,
                      dueDateController.text,
                      selectedSubject,
                      selectedYear,
                      provider);
                },
                child: Text('Submit'))
          ],
        ),
      )),
    );
  }
}
