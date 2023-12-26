import 'package:flutter/material.dart';
import 'package:student_management/models/models.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key, required this.teachersList});
  final List<Teacher> teachersList;
  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    List<Teacher> teachers = widget.teachersList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Staff List',style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
          child: ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(teachers[index].name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teachers[index].email),
                    ],
                  ),
                  leading: Text(teachers[index].id),
                  trailing: Text(teachers[index].role),
                ),
              );
            },
          )),
    );
  }
}
