class CategoryDTO {
  int id;
  String categoryName;
  String imgURL;

  CategoryDTO({this.id, this.categoryName, this.imgURL});

  factory CategoryDTO.fromJson(dynamic json) {
    return CategoryDTO(
      id: json['location_id'],
      categoryName: json['categoryName'],
      imgURL: json['imgUrl'],
    );
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => CategoryDTO.fromJson(map)).toList();
  }
}
