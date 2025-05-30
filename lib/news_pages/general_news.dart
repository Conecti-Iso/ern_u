import 'package:ern_u/constants/const_widgets.dart';
import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../service/news_service.dart';

class GeneralNews extends StatefulWidget {
  const GeneralNews({super.key});

  @override
  State<GeneralNews> createState() => _GeneralNewsState();
}

class _GeneralNewsState extends State<GeneralNews> {

  bool newsData = true;

  late Future<List<NewsModel>> news;

  @override
  void initState() {
    // TODO: implement initState
    news = NewsService().fetchNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
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
                    reverse: true,
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
