import 'dart:async';

import 'package:bloc_example/api_manager.dart';

import 'news_info.dart';

enum NewsAction { fetch, delete }

class NewsBloc {
  final API_Manager _api_manager = API_Manager();

  final _stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get _newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get _eventStream => _eventStreamController.stream;

  NewsBloc() {
    _eventStream.listen((event) async {
      if (event == NewsAction.fetch) {
        try {
          var news = await _api_manager.getNews();
          if (news != null) {
            _newsSink.add(news.articles);
          } else {
            _newsSink.addError("Something Went Wrong");
          }
        } on Exception catch (e) {
          _newsSink.addError("Something Went Wrong");
        }
      }
    });
  }
}
