import 'dart:convert';

import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../models/news_model.dart';



class NewsService {
  final String apiKey =  '2bd9bcec4fa44f01ae4ee7394d0cdae7';
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  final String newsDataApiKey =  'pub_53707d4c7355eb34ee99baef756a8488fbe78';
  final String newsDataBaseUrl = 'https://newsdata.io/api/1/latest';

  final String url = "https://uenr.edu.gh/news/";

  Future<List<NewsModel>> fetchNews() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Failed to load page");
    }

    final document = parser.parse(response.body);
    final List<Element> articles = document.querySelectorAll('article.elementor-post');

    List<NewsModel> news = [];

    for (var article in articles) {
      final titleElement = article.querySelector('h2.elementor-heading-title a');
      final imgElement = article.querySelector('img');

      if (titleElement != null && imgElement != null) {
        final title = titleElement.text.trim();
        final link = titleElement.attributes['href'] ?? '';
        final imageUrl = imgElement.attributes['src'] ?? '';

        news.add(
            NewsModel(title: title, link: link, imageUrl: imageUrl, sourceName: "Uner")
        );
      }
    }

    return news;
  }

  Future<NewsModel?> getDetails (NewsModel news) async {
    print(news.url);
    final response = await http.get(Uri.parse(news.link ?? ""));
    if (response.statusCode != 200) {
      throw Exception("Failed to load page");
    }

    // Parse the HTML document
    Document document = parser.parse(response.body);

    // Find the content container (adjust selector as needed)
    final contentElement = document.querySelector(
        'div.elementor-widget-theme-post-content'
    );

    if (contentElement != null) {
      // Extract image (if needed)
      final imageUrl = contentElement.querySelector('img')?.attributes['src'];


      // Extract paragraphs
      final paragraphs = contentElement.querySelectorAll('p');
      final articleText = paragraphs.map((p) => p.text.trim()).join("\n\n");


      if (imageUrl != null) {
        news.imageUrl = imageUrl;
      }

      news.content = articleText;

      return news;
    }

    return news;
  }

  Future<List<NewsModel>> fetchFromNewsData({String country ='gh', String category ='sports'}) async {
    final url = '$newsDataBaseUrl?country=$country&apiKey=$newsDataApiKey&q=$category';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['results'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception("Could not load Data");
    }
  }

  Future<List<NewsModel>> fetchGeneralNews({String country ='gh'}) async {
    final url = '$newsDataBaseUrl?country=$country&apiKey=$newsDataApiKey';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['results'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception("Could not load Data");
    }
  }

  Future<List<NewsModel>> fetchTechnologyNews({String country ='us', String category ='tech'}) async {
    final url = '$baseUrl?q=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception("Could not load Data");
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as parser;
// import 'package:html/dom.dart';
//
// class NewsItem {
//   final String title;
//   final String link;
//   final String imageUrl;
//
//   NewsItem({required this.title, required this.link, required this.imageUrl});
// }
//
// class NewsScraper {
//   final String url = "https://uenr.edu.gh/news/";
//
//   Future<List<NewsItem>> fetchNews() async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode != 200) {
//       throw Exception("Failed to load page");
//     }
//
//     final document = parser.parse(response.body);
//     final List<Element> articles = document.querySelectorAll('article.elementor-post');
//
//     List<NewsItem> news = [];
//
//     for (var article in articles) {
//       final titleElement = article.querySelector('h2.elementor-heading-title a');
//       final imgElement = article.querySelector('img');
//
//       if (titleElement != null && imgElement != null) {
//         final title = titleElement.text.trim();
//         final link = titleElement.attributes['href'] ?? '';
//         final imageUrl = imgElement.attributes['src'] ?? '';
//
//         news.add(NewsItem(title: title, link: link, imageUrl: imageUrl));
//       }
//     }
//
//     return news;
//   }
// }
