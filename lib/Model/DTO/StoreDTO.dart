class StoreDTO{
  int id;
  String name;
  String location;
  String imageUrl;

  StoreDTO({this.id, this.name, this.location, this.imageUrl});

  factory StoreDTO.fromJson(dynamic json){
    return StoreDTO(
      id: json['id'],
      name: json['name'],
      location: json['address'],
      imageUrl: json['image_url']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id" : id,
      "name" : name,
      "address": location,
      "image_url" : imageUrl
    };
  }
}