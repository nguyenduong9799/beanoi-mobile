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
}
