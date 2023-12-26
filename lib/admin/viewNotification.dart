import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotification extends StatefulWidget {
  const ViewNotification({super.key});

  @override
  State<ViewNotification> createState() => _ViewNotificationState();
}

List<Map<String, dynamic>> notifications = [];

class _ViewNotificationState extends State<ViewNotification> {
  Future<void> getNotifications() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch data from the "notifications" collection
      QuerySnapshot querySnapshot =
          await firestore.collection('notifications').get();

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
      appBar: AppBar(title: Text('Announcements'),),
      body: SafeArea(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> notification = notifications[index];
            return Card(
              child: ListTile(
                title: Text(notification['message']),
                subtitle: Text(notification['date']),
                trailing:Text(notification['view']),
              ),
            );
          },
        ),
      ),
    );
  }
}
