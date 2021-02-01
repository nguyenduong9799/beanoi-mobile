class BlogDTO{
  int id;
  String title;
  String imageUrl;
  String content;

  BlogDTO({this.id, this.title, this.imageUrl, this.content});

  factory BlogDTO.fromJson(dynamic json){
    return BlogDTO(
      id: json['id'],
      imageUrl: json['image_url'],
      content: json['blog_content'],
      title: json['title']
    );
  }
}