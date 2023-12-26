import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DailyAttendanceScreen extends StatefulWidget {
  const DailyAttendanceScreen(
      {Key? key,
      required this.currentUserId,
      required this.subject,
      required this.year})
      : super(key: key);
  final currentUserId;
  final year;
  final subject;
  @override
  _DailyAttendanceScreenState createState() => _DailyAttendanceScreenState();
}

class _DailyAttendanceScreenState extends State<DailyAttendanceScreen> {
  late String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  Future<List<String>> fetchAttendanceData() async {
  try {
    // Fetch attendance data based on year, subject, and date
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('studentAttentence')
        .where('year', isEqualTo: widget.year)
        .where('subject', isEqualTo: widget.subject)
        .where('date', isEqualTo: _selectedDate)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If attendance data is found, return the list of hours
      List<String> hours = querySnapshot.docs
          .map((doc) => doc['hour'])
          .whereType<String>() // Filter out non-string values
          .toList();

print(hours);
return hours;
    } else {
      // If no attendance data is found, return an empty list
      return [];
    }
  } catch (e) {
    print('Error fetching attendance data: $e');
    return [];
  }
}


  Widget buildAttendanceStatus(String hour) {
  return FutureBuilder<List<String>>(
    future: fetchAttendanceData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
        // Handle the case when data is null or empty
        return Text('No attendance data');
      } else {
        // Check if the user is present or absent during the specified hour
        bool isPresent = snapshot.data!.contains(hour);
        return Text(
          isPresent ? 'P' : 'A',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isPresent ? Colors.green : Colors.red,
          ),
        );
      }
    },
  );
}

  //calender
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
      });
      print('Selected Date: $_selectedDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Text(
                    _selectedDate.toString(),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              '09.00 - 10.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('09.00--10.00'),
            SizedBox(height: 10),
            Text(
              '10.00 - 11.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('10.00--11.00'),
            SizedBox(height: 10),
            Text(
              '11.10 - 12.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('11.10--12.00'),
            SizedBox(height: 10),
            Text(
              '12.00 - 01.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('12.00--01.00'),
            SizedBox(height: 10),
            Text(
              '02.00 - 03.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('02.00--03.00'),
            SizedBox(height: 10),
            Text(
              '04.00 - 05.00: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildAttendanceStatus('04.00--05.00'),
          ],
        ),
      ),
    );
  }
}
