import 'package:intl/intl.dart';

String formatPrice(double price) {
  return NumberFormat.simpleCurrency(locale: 'vi').format(price);
}

