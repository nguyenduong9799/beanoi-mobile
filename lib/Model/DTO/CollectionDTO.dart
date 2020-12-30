import 'package:unidelivery_mobile/Model/DTO/index.dart';

class CollectionDTO{
  int id;
  String name;
  List<ProductDTO> products;
  bool isSelected;

  CollectionDTO({this.id, this.name, this.products, this.isSelected});

  factory CollectionDTO.fromJson(dynamic json){
    return CollectionDTO(
      id: json['id'],
      name: json['name'],
      isSelected: false
    );
  }

  static List<CollectionDTO> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => CollectionDTO.fromJson(map)).toList();
  }
}