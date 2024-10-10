class BookModel {
  String? author;
  String? title;
  String? description;
  String? bookUrl;
  String? link;
  String? publishedAt;
  String? content;
  String? imageUrl;
  String? videoUrl;
  String? category;
  String? language;
  String? sourceName;

  BookModel({
    this.author,
    this.title,
    this.description,
    this.bookUrl,
    this.link,
    this.imageUrl,
    this.videoUrl,
    this.content,
    this.publishedAt,
    this.sourceName
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        author: json['author'],
        title: json['title'],
        description: json['description'],
        bookUrl: json['bookUrl'],
        link: json['link'],
        content: json['content'],
        publishedAt: json['publishedAt'],
        imageUrl: json['image_url'],
        videoUrl: json['video_url'],
        sourceName: json['source_name']
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'author' : author,
      'title' : title,
      'description' : description,
      'bookUrl' : bookUrl,
      'link' : link,
      'content' : content,
      'publishedAt' : publishedAt,
      'image_Url' : imageUrl,
      'video_Url' : videoUrl,
      'source_name' : sourceName
    };
  }
}

