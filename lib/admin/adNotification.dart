import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_management/admin/viewNotification.dart';
import 'package:student_management/provider/provider.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key});

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  TextEditingController announce = TextEditingController();
  String selectedView = 'Students';

  Future<void> addNotification(message, provider) async {
    try {
      // Access the Firestore instance
      // User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in the "submitted_assignments" collection
      await firestore.collection('notifications').add({
        'message': message,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'view': selectedView,
      });

      provider.showSnackbar(context, 'Announce Success ');
      announce.clear();
    } catch (e) {
      print('Error announce sub to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Announce'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewNotification()));
              },
              icon: Icon(Icons.notifications_none))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedView,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedView = newValue!;
                  });
                },
                items: <String>['Staff', 'Students']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: announce,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  addNotification(announce.text, provider);
                  announce.clear();
                  // Add your submit logic here
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
