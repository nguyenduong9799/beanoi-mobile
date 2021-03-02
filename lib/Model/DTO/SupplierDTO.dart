import 'package:unidelivery_mobile/Model/DTO/index.dart';

class SupplierDTO extends StoreDTO {
  String imageUrl;
  String address;

  SupplierDTO(
      {int id, String name, bool available, this.imageUrl, this.address})
      : super(id: id, name: name, available: available);

  factory SupplierDTO.fromJson(dynamic json) {
    return SupplierDTO(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      imageUrl: json['image_url'],
      available: json['is_available'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      "id": id,
      "name": name,
      "address": address,
      "image_url": imageUrl,
      "is_available": available
    };
  }
}
