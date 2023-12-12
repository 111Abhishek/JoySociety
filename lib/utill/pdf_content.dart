// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';

// import 'package:path_provider/path_provider.dart';

// class PDFViewerPage extends StatefulWidget {
//   final String pdfContent;

//   PDFViewerPage({required this.pdfContent});

//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }

// class _PDFViewerPageState extends State<PDFViewerPage> {
//   String? _pdfPath;

//   @override
//   void initState() {
//     super.initState();
//     _downloadAndOpenPDF();
//   }

//   Future<void> _downloadAndOpenPDF() async {
//     // Check if the app has permission to access the storage (to save the PDF)
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       // If not, request the permission
//       status = await Permission.storage.request();
//       if (!status.isGranted) {
//         // Permission denied, handle this case accordingly (e.g., show an error message)
//         return;
//       }
//     }

//     // Save the PDF content to a temporary file
//     final tempDir = await getTemporaryDirectory();
//     final filePath = '${tempDir.path}/temp.pdf';
//     final file = File(filePath);
//     await file.writeAsBytes(widget.pdfContent.codeUnits);

//     setState(() {
//       _pdfPath = filePath;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('PDF Viewer')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _pdfPath != null ? _handleViewPDF : null,
//           child: Text('Open PDF'),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleViewPDF() async {
//     // Use the flutter_pdfview package to display the PDF
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PDFView(
//           filePath: _pdfPath!,
//           enableSwipe: true,
//           swipeHorizontal: true,
//           autoSpacing: false,
//           pageFling: false,
//           onViewCreated: (PDFViewController pdfViewController) {
//             // When the controller is initialized, you can use it to control the PDF viewer
//           },
//           // onPageChanged: (int page, int total) {
//           //   // Handle page change events if needed
//           // },
//         ),
//       ),
//     );
//   }
// }
