import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'book_details.dart';


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
                padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
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
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Get.to(()=> BookDetails(book: book,));
          },
          child: Row(
            children: [
              Image.asset("assets/images/pdf-bg.png", height: 40,),
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title ?? "Empty Title", style: const TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  const Text("pdf")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: const Icon(Icons.add),
        // ),
        body: SingleChildScrollView(
          child: Center(
              child: getAllBooks(context)
          ),
        ),
      );
  }
}
