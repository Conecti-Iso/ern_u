// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
//
// class PDFScreen extends StatelessWidget {
//   final String path;
//
//   const PDFScreen({Key? key, required this.path}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//         backgroundColor: Colors.teal,
//       ),
//       body: PDFView(
//         filePath: path,
//         enableSwipe: true,
//         swipeHorizontal: true,
//         autoSpacing: false,
//         pageFling: false,
//         onError: (error) {
//           print(error.toString());
//         },
//         onPageError: (page, error) {
//           print('$page: ${error.toString()}');
//         },
//       ),
//     );
//   }
// }