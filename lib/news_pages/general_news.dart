// import 'package:ern_u/constants/const_widgets.dart';
// import 'package:flutter/material.dart';
//
// import '../models/news_model.dart';
// import '../service/news_service.dart';
//
// class GeneralNews extends StatefulWidget {
//   const GeneralNews({super.key});
//
//   @override
//   State<GeneralNews> createState() => _GeneralNewsState();
// }
//
// class _GeneralNewsState extends State<GeneralNews> {
//
//   bool newsData = true;
//
//   late Future<List<NewsModel>> news;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     news = NewsService().fetchNews();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: const Color(0xFFEEEEEE),
//         body: FutureBuilder<List<NewsModel>>(
//             future: news,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.hasData) {
//                 return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     reverse: true,
//                     itemBuilder: (context, index) {
//                       final newsItem = (snapshot).data![index];
//                       return newsCard(newsItem, width);
//                     });
//               } else if(!snapshot.hasData) {
//                 return const Center(child: Text("No Data Found"),);
//               }  else {
//                 return const Center(child: Text("No Data Found"),);
//               }
//             }
//         )
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../constants/const_widgets.dart';
import '../models/news_model.dart';
import '../service/news_service.dart';

class GeneralNews extends StatefulWidget {
  const GeneralNews({super.key});

  @override
  State<GeneralNews> createState() => _GeneralNewsState();
}

class _GeneralNewsState extends State<GeneralNews> {
  late Future<List<NewsModel>> news;
  bool isRefreshing = false;

  @override
  void initState() {
    news = NewsService().fetchNews();
    super.initState();
  }

  Future<void> _refreshNews() async {
    setState(() {
      isRefreshing = true;
    });

    news = NewsService().fetchNews();

    // Add a small delay to make the refresh feel more natural
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: FutureBuilder<List<NewsModel>>(
            future: news,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        "Loading news...",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to load news',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pull down to try again',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    itemBuilder: (context, index) {
                      final newsItem = snapshot.data![index];
                      return newsCard(newsItem, width);
                    }
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No News Available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pull down to refresh',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}