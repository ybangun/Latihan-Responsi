class Report {
  final int id;
  final String title;
  final String imageUrl;
  final String publishedAt;

  Report({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'],
    );
  }
}