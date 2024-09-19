import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news_model.dart';



class NewsService {
  final String apiKey =  '2bd9bcec4fa44f01ae4ee7394d0cdae7';
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  final String newsDataApiKey =  'pub_53707d4c7355eb34ee99baef756a8488fbe78';
  final String newsDataBaseUrl = 'https://newsdata.io/api/1/latest';

  Future<List<NewsModel>> fetchNews({String country ='us', String category ='sports'}) async {
    // final url = '$baseUrl?country=$country&category=$category&apiKey=$apiKey';
    final url = '$baseUrl?category=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      print(".........${response.statusCode}");
      throw Exception("Could not load Data");
    }
  }

  Future<List<NewsModel>> fetchFromNewsData({String country ='gh', String category ='sports'}) async {
    final url = '$newsDataBaseUrl?country=$country&apiKey=$newsDataApiKey&q=$category';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['results'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      print(".........${response.statusCode}");
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
      print(".........${response.statusCode}");
      throw Exception("Could not load Data");
    }
  }

  Future<List<NewsModel>> fetchTechnologyNews({String country ='us', String category ='tech'}) async {
    // final url = '$baseUrl?country=$country&category=$category&apiKey=$apiKey';
    final url = '$baseUrl?q=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      print(".........${response.statusCode}");
      throw Exception("Could not load Data");
    }
  }
}