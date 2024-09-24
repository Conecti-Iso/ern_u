import 'package:ern_u/constants/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';
import '../service/news_service.dart';

class SportsNews extends StatefulWidget {
  const SportsNews({super.key});

  @override
  State<SportsNews> createState() => _SportsNewsState();
}

class _SportsNewsState extends State<SportsNews> {

  bool newsData = true;

  late Future<List<NewsModel>> news;

  @override
  void initState() {
    // TODO: implement initState
    news = NewsService().fetchFromNewsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: FutureBuilder<List<NewsModel>>(
            future: news,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final newsItem = (snapshot).data![index];
                      return newsCard(newsItem, width);
                    });
              } else if(!snapshot.hasData) {
                return const Center(child: Text("No Data Found"),);
              }  else {
                return const Center(child: Text("No Data Found"),);
              }
            }
        )
    );
  }
}
