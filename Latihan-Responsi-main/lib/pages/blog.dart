import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/blog_model.dart';

Future<Blog> fetchBlog(int id) async {
  final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/blogs/$id'));

  if (response.statusCode == 200) {
    return Blog.fromJson(json.decode(response.body));
  } else if (response.statusCode == 429) {
    throw Exception('Too many requests. Please try again later.');
  } else {
    throw Exception('Failed to load Blog');
  }
}

Future<List<Blog>> fetchRandomBlogs(int count) async {
  final random = Random();
  List<Future<Blog>> futures = [];

  for (int i = 0; i < count; i++) {
    int randomId = random.nextInt(1374) + 1;
    futures.add(fetchBlog(randomId));
  }

  return Future.wait(futures);
}

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogListState createState() => _BlogListState();
}

class _BlogListState extends State<BlogPage> {
  late Future<List<Blog>> futureBlogs;

  @override
  void initState() {
    super.initState();
    futureBlogs = fetchRandomBlogs(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: FutureBuilder<List<Blog>>(
        future: futureBlogs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Blog> blogs = snapshot.data!;
            return ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        blogs[index].imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                    title: Text(blogs[index].title),
                    subtitle: Text(blogs[index].publishedAt),
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