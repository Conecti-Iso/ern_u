import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/models/book_model.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getAllBooks(
      BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("books").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  BookModel book = BookModel.fromJson(snapshot.data!.docs[index].data());
                  return bookCard(book, context);
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        });
  }

  bookCard(BookModel book, BuildContext c) {
    return Card(
      child: Text(book.title ?? "Empty Title"),
    );
  }


  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Center(
          child: getAllBooks(context)
        ),
      );
  }
}
