import 'package:bloc_example/api_manager.dart';
import 'package:bloc_example/news_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'news_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // late Future<NewsModel> _newsModel;
  final newsBLoc = NewsBloc();
  @override
  void initState() {
    newsBLoc.eventSink.add(NewsAction.fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: StreamBuilder<List<Article>>(
        stream: newsBLoc.newsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("No Data To Display"));
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data![index];
                  var formattedTime =
                      DateFormat('dd MMM - HH:mm').format(article.publishedAt!);
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                article.urlToImage!,
                                fit: BoxFit.cover,
                              )),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formattedTime),
                              Text(
                                article.title!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                article.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
