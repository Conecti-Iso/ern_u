import 'package:ern_u/home_page/general_news.dart';
import 'package:ern_u/home_page/sports_news.dart';
import 'package:ern_u/home_page/technology_news.dart';
import 'package:flutter/material.dart';

class NewsTabs extends StatefulWidget {
  const NewsTabs({super.key});

  @override
  State<NewsTabs> createState() => _NewsTabsState();
}

class _NewsTabsState extends State<NewsTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        title: const Text("News", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: TabBar(
              unselectedLabelStyle: const TextStyle(fontSize: 14),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius. circular(40),
                ),
                splashBorderRadius: BorderRadius. circular(40),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                tabs: const [
              Text("General"),
              Text("Sports"),
              Text("Technology")
            ])
        ),
      ),
      body: const TabBarView(children: [
        GeneralNews(),
        SportsNews(),
        TechnologyNews()
      ]),
    ));
  }
}
