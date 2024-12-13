class Blog {
  final int id;
  final String title;
  final String imageUrl;
  final String publishedAt;

  Blog({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      publishedAt: json['published_at'],
    );
  }
}