import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/service/memo_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../home_page/Books/memo_details.dart';
import '../../models/memo_model.dart';
import '../app_colors.dart';

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
    final MemoService memoService = MemoService();
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
            Text(memo.memoDescription, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.attachment,color: AppColor.kWhite,),
              label: Text('View Attached Memo',style: TextStyle(color: AppColor.kWhite),),
              onPressed: () async {
                await memoService.incrementViewCount(memo.id);
                print("Memo ID: ${memo.id}");

                // Navigate to MemoDetails page
                Get.to(() => MemoDetails(memo: memo));
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