import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_management/models/models.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({super.key, required this.year});
  final year;
  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  void initState() {
    super.initState();
    getStudentList();
  }

  String? collection;
  List<Student> studentList = [];
  Future<void> getStudentList() async {
    if (widget.year == 'First Year ') {
      collection = '1st year';
    } else if (widget.year == 'Second Year ') {
      collection = '2nd year';
    } else if (widget.year == 'Third Year ') {
      collection = '3rd year';
    }
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection(collection!).get();

      List<Student> students = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Student(
            id: data['id'] ?? '',
            name: data['name'] ?? '',
            email: data['email'] ?? '',
            year: data['year'] ?? '');
      }).toList();

      print(students.length);

      setState(() {
        studentList = students;
      });
    } catch (e) {
      print('Error getting students: $e');
      // Return an empty list in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Students List',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: studentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(studentList[index].name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(studentList[index].email),
                ],
              ),
              leading: Text(studentList[index].id),
            ),
          );
        },
      )),
    );
  }
}
