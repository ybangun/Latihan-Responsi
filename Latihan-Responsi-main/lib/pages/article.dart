import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/article_model.dart';

Future<Article> fetchArticle(int id) async {
  final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/articles/$id'));

  if (response.statusCode == 200) {
    return Article.fromJson(json.decode(response.body));
  } else if (response.statusCode == 429) {
    throw Exception('Too many requests. Please try again later.');
  } else {
    throw Exception('Failed to load article');
  }
}

Future<List<Article>> fetchRandomArticles(int count) async {
  final random = Random();
  List<Future<Article>> futures = [];

  for (int i = 0; i < count; i++) {
    int randomId = random.nextInt(24528) + 1;
    futures.add(fetchArticle(randomId));
  }

  return Future.wait(futures);
}

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticlePage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchRandomArticles(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Article> articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        articles[index].imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                    title: Text(articles[index].title),
                    subtitle: Text(articles[index].publishedAt),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}