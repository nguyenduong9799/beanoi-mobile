const defaultImg =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Ficons8-rice-bowl-48.png?alt=media&token=5a66159a-0bc1-4527-857d-7fc2801026f4";

class CategoryDTO {
  int id;
  int position;
  String categoryName;
  String imgURL;
  bool showOnHome;

  CategoryDTO({
    this.id,
    this.categoryName,
    this.imgURL,
    this.showOnHome = false,
    this.position = 0,
  });

  factory CategoryDTO.fromJson(dynamic json) {
    return CategoryDTO(
      id: json['id'],
      categoryName: json['category_name'],
      imgURL: json['pic_url'] ?? defaultImg,
      showOnHome: json['show_on_home'] as bool,
      position: json['position'] as int,
    );
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => CategoryDTO.fromJson(map)).toList();
  }
}
