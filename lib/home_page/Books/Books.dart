import 'package:ern_u/screens/books_screen.dart';
import 'package:flutter/material.dart';


class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> with SingleTickerProviderStateMixin{
  late final _tabController = TabController(length: 3, vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFEEEEEE),
        toolbarHeight: 0,
        bottom: TabBar(
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Books",
            ),
            Tab(
              text: "Memos",
            )
          ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          BooksScreen(),
          Center(child: Text("Memos")),
        ],
      ),
    );
  }
}
