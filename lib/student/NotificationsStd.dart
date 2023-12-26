import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotificationStudent extends StatefulWidget {
  const ViewNotificationStudent({super.key});

  @override
  State<ViewNotificationStudent> createState() => _ViewNotificationStudentState();
}

List<Map<String, dynamic>> notifications = [];

class _ViewNotificationStudentState extends State<ViewNotificationStudent> {
  Future<void> getNotifications() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch data from the "notifications" collection
      QuerySnapshot querySnapshot =
          await firestore.collection('notifications')
           .where('view', isEqualTo: 'Students')
          .get();

      // Extract data from each document and return as a list of maps
      List<Map<String, dynamic>> notifications1 = querySnapshot.docs.map((doc) {
        return {
          'message': doc['message'],
          'date': doc['date'],
          'view': doc['view'],
        };
      }).toList();
      setState(() {
        notifications = notifications1;
        print(notifications.length);
      });
    } catch (e) {
      print('Error getting notifications from Firebase: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications'),),
      body: SafeArea(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> notification = notifications[index];
            return Card(
              child: ListTile(
                title: Text(notification['message']),
               
                trailing:Text(notification['date']),
              ),
            );
          },
        ),
      ),
    );
  }
}
