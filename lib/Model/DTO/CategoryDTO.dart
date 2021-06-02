const defaultImg =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Ficons8-rice-bowl-48.png?alt=media&token=5a66159a-0bc1-4527-857d-7fc2801026f4";

class CategoryDTO {
  int id;
  String categoryName;
  String imgURL;

  CategoryDTO({this.id, this.categoryName, this.imgURL});

  factory CategoryDTO.fromJson(dynamic json) {
    return CategoryDTO(
      id: json['cate_id'],
      categoryName: json['cate_name'],
      imgURL: json['imgUrl'] ?? defaultImg,
    );
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => CategoryDTO.fromJson(map)).toList();
  }
}
