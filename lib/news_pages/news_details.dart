import 'package:ern_u/models/news_model.dart';
import 'package:ern_u/service/news_service.dart';
import 'package:flutter/material.dart';


class NewsDetails extends StatefulWidget {
  final NewsModel news;
  const NewsDetails({
    super.key,
    required this.news
  });

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  final NewsService newsService = NewsService();

  late Future<NewsModel?> news;

  @override
  void initState() {

    getDetails();

    super.initState();
  }

  void getDetails() async {
    news = newsService.getDetails(widget.news);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.news.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold),),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: news,
            builder: (context, snap) {
              if(snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              } else if(snap.hasData) {
                final updatedNews = snap.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        height: height * .3,
                        child: Image.network(updatedNews!.imageUrl ?? "", fit: BoxFit.fill,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Text(
                            widget.news.title ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 30
                          ),
                        child: Text(widget.news.content ?? ""),
                      )
                    ],
                  ),
                );
              }
              return const Center(child: Text("No Data Found"),);
            }
        )
    );
  }
}
