class MenuDTO {
  int menuId;
  bool isAvailable;
  List<String> timeFromTo;
  List<TimeSlots> timeSlots;
  int timeFromDb;
  int timeToDb;
  List<int> dayFilter;
  int dayFilterDb;
  String menuName;

  MenuDTO(
      {this.menuId,
      this.isAvailable,
      this.timeFromTo,
      this.timeSlots,
      this.timeFromDb,
      this.timeToDb,
      this.dayFilter,
      this.dayFilterDb,
      this.menuName});

  MenuDTO.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    isAvailable = json['is_available'];
    timeFromTo = json['time_from_to'].cast<String>();
    if (json['time_slots'] != null) {
      timeSlots = <TimeSlots>[];
      json['time_slots'].forEach((v) {
        timeSlots.add(new TimeSlots.fromJson(v));
      });
    }
    // if (json['selected_time_slot'] != null) {
    //   MenuDTO menuDTO = MenuDTO();
    //   menuDTO.selectedMenuTimeSlots =
    //       TimeSlots.fromJson(json['selected_time_slot']);
    // }
    timeFromDb = json['time_from_db'];
    timeToDb = json['time_to_db'];
    dayFilter = json['day_filter'].cast<int>();
    dayFilterDb = json['day_filter_db'];
    menuName = json['menu_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['is_available'] = this.isAvailable;
    data['time_from_to'] = this.timeFromTo;
    if (this.timeSlots != null) {
      data['time_slots'] = this.timeSlots.map((v) => v.toJson()).toList();
    }
    // data['selected_time_slot'] = selectedMenuTimeSlots?.toJson();
    data['time_from_db'] = this.timeFromDb;
    data['time_to_db'] = this.timeToDb;
    data['day_filter'] = this.dayFilter;
    data['day_filter_db'] = this.dayFilterDb;
    data['menu_name'] = this.menuName;
    return data;
  }
}

class TimeSlots {
  int id;
  String arriveTime;
  String checkoutTime;

  TimeSlots({this.id, this.arriveTime, this.checkoutTime});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    arriveTime = json['arrive_time'];
    checkoutTime = json['checkout_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['arrive_time'] = this.arriveTime;
    data['checkout_time'] = this.checkoutTime;
    return data;
  }
}
