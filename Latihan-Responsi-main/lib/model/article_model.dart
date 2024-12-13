class Article {
  final int id;
  final String title;
  final String imageUrl;
  final String publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'],
    );
  }
}