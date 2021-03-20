import 'package:unidelivery_mobile/Model/DTO/index.dart';

class CampusDTO extends StoreDTO {
  List<LocationDTO> locations;
  List<TimeSlot> timeSlots;
  TimeSlot selectedTimeSlot;

  CampusDTO({
    int id,
    String name,
    bool available,
    this.locations,
  }) : super(name: name, id: id, available: available);

  factory CampusDTO.fromJson(dynamic json) {
    CampusDTO campusDTO = CampusDTO(
        id: json['id'], name: json['name'], available: json['is_available']);

    if (json['locations'] != null) {
      var list = json['locations'] as List;
      campusDTO.locations = list.map((e) => LocationDTO.fromJson(e)).toList();
    }

    if (json['time_slots'] != null) {
      var list = json['time_slots'] as List;
      campusDTO.timeSlots = list.map((e) {
        return TimeSlot.fromJson(e);
      }).toList();
    }

    if (json['selected_time_slot'] != null) {
      campusDTO.selectedTimeSlot =
          TimeSlot.fromJson(json['selected_time_slot']);
    }

    return campusDTO;
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return {
      "id": id,
      "name": name,
      "locations": locations.map((e) => e.toJson()).toList(),
      "is_available": available,
      "time_slots": timeSlots.map((e) => e.toJson()).toList(),
      "selected_time_slot": selectedTimeSlot?.toJson()
    };
  }
}

class LocationDTO {
  int id;
  String address;
  String lat;
  String long;
  bool isSelected;

  LocationDTO({this.id, this.address, this.lat, this.long, this.isSelected});

  factory LocationDTO.fromJson(dynamic json) {
    return LocationDTO(
        id: json['location_id'],
        address: json['address'],
        lat: json['lat'],
        long: json['long'],
        isSelected: json['isSelected'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      "location_id": id,
      "address": address,
      "lat": lat,
      "long": long,
      "isSelected": isSelected
    };
  }
}

class TimeSlot {
  int menuId;
  String from;
  String to;
  String arrive;
  bool available;

  TimeSlot({this.menuId, this.from, this.to, this.available, this.arrive});

  factory TimeSlot.fromJson(dynamic json) {
    return TimeSlot(
        menuId: json['menu_id'],
        from: json['from'],
        to: json['to'].toString(),
        available: json['available'] ?? false,
        arrive: json['arrive_time']);
  }

  Map<String, dynamic> toJson() {
    return {
      "menu_id": menuId,
      "from": from,
      "to": to,
      "available": available,
      'arrive_time': arrive
    };
  }
}
