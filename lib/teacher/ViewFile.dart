// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;

// class FileTypeChecker extends StatefulWidget {
//   final String? downloadURL;

//   FileTypeChecker({Key? key, required this.downloadURL}) : super(key: key);

//   @override
//   _FileTypeCheckerState createState() => _FileTypeCheckerState();
// }

// class _FileTypeCheckerState extends State<FileTypeChecker> {
//   // String? contentType;

//   @override
//   void initState() {
//     super.initState();
//     // checkContentType();
//   }

//   // Future<void> checkContentType() async {
//   //   try {
//   //     http.Response response = await http.head(Uri.parse(widget.downloadURL!));
//   //     contentType = response.headers['content-type'];
//   //     setState(() {});
//   //   } catch (e) {
//   //     print('Error checking content type: $e');
//   //   }
//   // }
//   void launchPDFViewer(String pdfURL) async {
//     // Use a package like 'flutter_pdfview' to open a PDF viewer
//     // Example: https://pub.dev/packages/flutter_pdfview
   
//     print('Opening PDF Viewer for: $pdfURL');
//     // Implement the logic to open a PDF viewer
//   }

//   void displayImage(String imageURL) {
//     // Display the image using the Image widget
//     Image.network(imageURL);
//     print('Displaying image: $imageURL');
//     // Example:
//     // Image.network(imageURL)
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('File Viewer'),
//       ),
//       body:
//             if (widget.downloadURL != null) {
//               if (widget.downloadURL!.contains('pdf')) {
//                 // Open PDF viewer
//                 launchPDFViewer(widget.downloadURL!);
//               } else if (widget.downloadURL!.contains('jpg')||widget.downloadURL!.contains('png')) {
//                 // Display image using Image widget
//                 displayImage(widget.downloadURL!);
//               } else {
//                 // Handle other content types or show an error
//                 print('Unsupported content type: ${widget.downloadURL}');
//               }
//             }
        
         
       
//     );
  

//   }}
