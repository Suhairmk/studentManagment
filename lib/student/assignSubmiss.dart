import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:student_management/models/models.dart';
import 'package:student_management/provider/provider.dart';

class AssignmentSubmission extends StatefulWidget {
  const AssignmentSubmission({
    Key? key,
    required this.index,
    required this.subject,
    required this.year,
    required this.assgnId,
    required this.stdId,
    required this.stdName,
  }) : super(key: key);

  final index;
  final year;
  final subject;
  final assgnId;
  final stdId;
  final stdName;

  @override
  State<AssignmentSubmission> createState() => _AssignmentSubmissionState();
}

class _AssignmentSubmissionState extends State<AssignmentSubmission> {
  String? imgUrl; // Variable to store the selected file path
  String submitDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Function to handle file picking
  Future<void> pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          imgUrl = result.files.single.path;
        });
      }
    } catch (e) {
      print('Error picking PDF file: $e');
    }
  }

  // Store to Firebase
  Future<void> submitAssignmentToFirebase(
      filePath, submissionDate, provider) async {
    try {
      // Access the Firestore instance
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      AssignmentSubm assignment = AssignmentSubm(
        assignmentId: widget.assgnId,
        name: widget.stdName,
        studentId: widget.stdId,
        submissionDate: submissionDate,
        subject: widget.subject,
        year: widget.year,
        imgUrl: filePath,
      );

      // Create a new document in the "submitted_assignments" collection
      await firestore
          .collection('submitted_assignments')
          .add(assignment.toJson());
      provider.showSnackbar(context, 'Assignment Submited Successfully',Colors.green);
      setState(() {
        imgUrl = 'Assignment uploaded';
      });
      print('Assignment submitted to Firebase successfully!');
    } catch (e) {
      provider.showSnackbar(context, 'Invalid',Colors.red);
      print('Error submitting assignment to Firebase: $e');
    }
  }

  // Upload image and get download URL
  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('your_storage_path/$fileName');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e, stackTrace) {
      print('Error uploading image: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment Submission'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickPDFFile,
              child: Text('Pick PDF File'),
            ),
            SizedBox(height: 20),
            if (imgUrl != null) Text('Selected File: $imgUrl'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                provider.startLoading();
                // Add logic to handle the submission of the selected PDF file
                if (imgUrl != null) {
                  // Perform the submission logic here
                  File imageFile = File(imgUrl!);
                  String? downloadURL =
                      await uploadImageAndGetDownloadURL(imageFile);

                  if (downloadURL != null) {
                    // You can use the downloadURL as needed, for example, store it in Firestore.
                    print('Image Download URL: $downloadURL');
                    print('Submitting PDF: $imgUrl');
                    submitAssignmentToFirebase(
                        downloadURL, submitDate, provider);
                  } else {
                    print('Image upload failed');
                  }
                } else {
                  // Show an error or prompt the user to pick a file
                  print('Please pick a PDF file before submitting.');
                }
              },
              child: provider.isLoading
                  ? Container(
                      height: 30,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ))
                  : Text(
                      'Submit ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
