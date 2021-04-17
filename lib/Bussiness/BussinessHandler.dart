import 'package:unidelivery_mobile/Model/DTO/index.dart';

class BussinessHandler {
  static const double BEAN_RATE = 0.5; // 1k VND = 1 bean
  static const int PRICE_QUANTITY = 10;

  static int beanReward(double total) {
    return (total * BEAN_RATE).round();
  }

  static double countPrice(List<double> prices, int quantity,
      [double weight = 1]) {
    double total = 0;

    for (int i = 0; i < quantity; i++) {
      if (i >= PRICE_QUANTITY) {
        total += prices[PRICE_QUANTITY - 1];
      } else
        total += prices[i];
    }

    return total;
  }

  static CampusDTO setSelectedTime(CampusDTO campus) {
    campus.selectedTimeSlot = null;
    if (campus.timeSlots != null && campus.timeSlots.isNotEmpty) {
      for (int i = 0; i < campus.timeSlots.length; i++) {
        if (campus.timeSlots[i].available) {
          campus.selectedTimeSlot = campus.timeSlots[i];
          break;
        }
      }
      if (campus.selectedTimeSlot == null) {
        campus.selectedTimeSlot = campus.timeSlots[campus.timeSlots.length - 1];
      }
    }
    return campus;
  }
}
