import 'dart:convert';

import 'package:bloc_example/news_info.dart';
import 'package:http/http.dart' as http;

class API_Manager {
  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get(Uri.parse(
          'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=ac75bfb60af94b65a6bee393e1b0ba55'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);
        newsModel = NewsModel.fromJson(jsonMap);
      }
    } on Exception {
      return newsModel;
    }
    return newsModel;
  }
}
