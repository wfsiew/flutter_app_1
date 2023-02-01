class PhotoList {

  String id;
  String author;
  num width;
  num height;
  String url;
  String downloadUrl;

  PhotoList({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PhotoList.fromJson(Map<String, dynamic> json) {
    return PhotoList(
      id: json['id'],
      author: json['author'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      downloadUrl: json['download_url'],
    );
  }
}