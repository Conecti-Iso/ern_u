import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/memo_model.dart';

class MemoDetails extends StatefulWidget {
  final Memo memo;
  const MemoDetails({super.key, required this.memo});

  @override
  State<MemoDetails> createState() => _MemoDetailsState();
}

class _MemoDetailsState extends State<MemoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.memo.memoTitle),
          centerTitle: true,
        ),
        body: SfPdfViewer.network(widget.memo.memoFileUrl)
    );
  }
}
