import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String email;
  final String year;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'year': year,
      // Include isPresent in the JSON representation
    };
  }

  factory Student.fromSnapshot(DocumentSnapshot snapshot) {
    return Student(
      id: snapshot['id'],
      name: snapshot['name'],
      email: snapshot['email'],
      year: snapshot['year'],
      // Populate isPresent from the snapshot
    );
  }
}

class Teacher {
  final String id;
  final String name;
  final String email;
  final String role;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert the teacher object to a map for storing in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Create a teacher object from a map retrieved from Firestore
  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
    );
  }
}

//attentence

class StudentAttentence {
  final String teacherId;
  final String date;
  final String year;
  final String hour;
  final String subject;
  final List<int> studentList; // Add isPresent property

  StudentAttentence({
    required this.teacherId,
    required this.date,
    required this.year,
    required this.hour,
    required this.subject,
    required this.studentList, // Initialize isPresent as an optional parameter
  });

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'date': date,
      'year': year,
      'hour': hour,
      'subject': subject,
      'studentList':
          studentList, // Include isPresent in the JSON representation
    };
  }

  factory StudentAttentence.fromSnapshot(DocumentSnapshot snapshot) {
    return StudentAttentence(
      teacherId: snapshot[' teacherId'],
      date: snapshot['date'],
      year: snapshot['year'],
      hour: snapshot['hour'],
      subject: snapshot['subject'],
      studentList:
          snapshot['studentList'], // Populate isPresent from the snapshot
    );
  }
}

class AssignmentQstn {
  final String title;
  final String description;
  final String dueDate;
  final String subject;
  final String year;

  AssignmentQstn({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.subject,
    required this.year,
  });
}

class AssignmentSubm {
  final String assignmentId;
  final String studentId;
  final String name;
  final String submissionDate;
  final String subject;
  final String year;
  final String imgUrl;

  AssignmentSubm({
    required this.assignmentId,
    required this.studentId,
    required this.name,
    required this.submissionDate,
    required this.subject,
    required this.year,
    required this.imgUrl,
  });

factory AssignmentSubm.fromMap(Map<String, dynamic> map) {
    return AssignmentSubm(
      assignmentId: map['assignmentId'] ?? '',
      studentId: map['studentId'] ?? '',
      name: map['name'] ?? '',
      submissionDate: map['submissionDate'] ?? '',
      subject: map['subject'] ?? '',
      year: map['year'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignmentId': assignmentId,
      'studentId': studentId,
      'name':name,
      'submissionDate': submissionDate,
      'subject': subject,
      'year': year,
      'imgUrl': imgUrl,
    };
  }
}
