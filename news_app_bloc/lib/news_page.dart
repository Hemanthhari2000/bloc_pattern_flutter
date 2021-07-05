import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app_bloc/news_bloc.dart';
import 'package:intl/intl.dart';
import 'news_info.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final newsBloc = NewsBloc();

  @override
  void initState() {
    newsBloc.eventSink.add(NewsAction.Fetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Container(
        child: StreamBuilder<List<Article>>(
          stream: newsBloc.newsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data![index];
                    var formattedTime = DateFormat('dd MMM - HH:mm')
                        .format(article.publishedAt!);
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
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.network(
                                    "https://designshack.net/wp-content/uploads/placeholder-image.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(formattedTime),
                                Text(
                                  article.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
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
            } else
              // return Center(child: CircularProgressIndicator());
              return SpinKitFadingFour(
                color: Colors.blue,
                size: 50,
              );
          },
        ),
      ),
    );
  }
}
