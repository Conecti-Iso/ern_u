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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: TabBar(
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
          Center(child: Text("Books")),
          Center(child: Text("Memos")),
        ],
      ),
    );
  }
}
