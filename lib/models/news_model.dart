class NewsModel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? link;
  String? urlToImage;
  String? publishedAt;
  String? content;
  List<String>? country;
  String? imageUrl;
  String? videoUrl;
  String? category;
  String? language;
  String? sourceName;

  NewsModel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.link,
    this.urlToImage,
    this.imageUrl,
    this.videoUrl,
    this.content,
    this.publishedAt,
    this.sourceName
  });

  String getImage() {
    if(imageUrl == null) {
      return urlToImage ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";
    } else if (urlToImage == null) {
      return imageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";
    } else {
      return "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg";
    }
  }

  String getLink(){
    if(link == null) {
      return url ?? "";
    } else if (url == null) {
      return link ?? "";
    } else {
      return "";
    }
  }

  String getSource() {
    if(sourceName == null) {
      return author ?? "";
    } else if (author == null) {
      return sourceName ?? "";
    }
    return "";
  }


  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
        author: json['author'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        link: json['link'],
        urlToImage: json['urlToImage'],
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
      'url' : url,
      'link' : link,
      'urlToImage' : urlToImage,
      'content' : content,
      'publishedAt' : publishedAt,
      'image_Url' : imageUrl,
      'video_Url' : videoUrl,
      'source_name' : sourceName
    };
  }
}

