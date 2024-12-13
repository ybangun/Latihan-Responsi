import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/report_model.dart';

Future<Report> fetchReport(int id) async {
  final response = await http.get(Uri.parse('https://api.spaceflightnewsapi.net/v4/reports/$id'));

  if (response.statusCode == 200) {
    return Report.fromJson(json.decode(response.body));
  } else if (response.statusCode == 429) {
    throw Exception('Too many requests. Please try again later.');
  } else {
    throw Exception('Failed to load Report');
  }
}

Future<List<Report>> fetchRandomReports(int count) async {
  final random = Random();
  List<Future<Report>> futures = [];

  for (int i = 0; i < count; i++) {
    int randomId = random.nextInt(1415) + 1;
    futures.add(fetchReport(randomId));
  }

  return Future.wait(futures);
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportPage> {
  late Future<List<Report>> futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = fetchRandomReports(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: FutureBuilder<List<Report>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Report> reports = snapshot.data!;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.network(
                        reports[index].imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                    ),
                    title: Text(reports[index].title),
                    subtitle: Text(reports[index].publishedAt),
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