import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_page/Books/PDFs_screen.dart';
import '../../models/memo_model.dart';
import '../app_colors.dart';
import 'package:http/http.dart' as http;

class MemoDetailScreen extends StatelessWidget {
  final Memo memo;

  const MemoDetailScreen({super.key, required this.memo});

  // Future<void> _openPDF(BuildContext context) async {
  //   final url = memo.memoFileUrl;
  //   final filename = url.substring(url.lastIndexOf("/") + 1);
  //   var request = await http.get(Uri.parse(url));
  //   var bytes = request.bodyBytes;
  //   final dir = await getApplicationDocumentsDirectory();
  //   File file = File('${dir.path}/$filename');
  //   await file.writeAsBytes(bytes);
  //   print("_______________");
  //   print('\n');
  //   print('\n');
  //   print(url);
  //   print(filename);
  //   print(request.body);
  //   print('\n');
  //   print("\n");
  //   print("_________");
  //
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PDFScreen(path: file.path),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Details',style: TextStyle(color: AppColor.kWhite),),
        backgroundColor: AppColor.kPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              memo.memoTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('From: ${memo.from}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(memo.memoDescription, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            // ElevatedButton.icon(
            //   icon: Icon(Icons.picture_as_pdf),
            //   label: Text('View PDF'),
            //   onPressed: () => _openPDF(context),
            //   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            // ),
            ElevatedButton.icon(
              icon: Icon(Icons.attachment,color: AppColor.kWhite,),
              label: Text('View Attached Memo',style: TextStyle(color: AppColor.kWhite),),
              onPressed: () async {
                if (await canLaunch(memo.memoFileUrl)) {
                  await launch(memo.memoFileUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open the file')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.kPrimary),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     await _memoService.updateMemoStatus(memo.id, 'viewed');
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Memo marked as viewed')),
      //     );
      //   },
      //   label: Text('Mark as Viewed'),
      //   icon: Icon(Icons.check),
      //   backgroundColor: Colors.teal,
      // ),
    );
  }
}