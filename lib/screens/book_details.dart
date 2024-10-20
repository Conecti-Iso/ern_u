import 'package:flutter/material.dart';
import 'package:ern_u/models/book_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookDetails extends StatefulWidget {
  final BookModel book;
  const BookDetails({super.key, required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool _isLoading = true; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title ?? ""),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.book.bookUrl ?? "",
            onDocumentLoaded: (details) {
              setState(() {
                _isLoading = false; // PDF loaded successfully
              });
            },
            onDocumentLoadFailed: (details) {
              setState(() {
                _isLoading = false; // Stop loading if an error occurs
              });
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading indicator
            ),
        ],
      ),
    );
  }
}
