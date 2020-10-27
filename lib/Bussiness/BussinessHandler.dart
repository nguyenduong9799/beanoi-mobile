class BussinessHandler {
  static const double BEAN_RATE = 1000; // 1k VND = 1 bean
  static const int PRICE_QUANTITY = 10;

  static int beanReward(double total) {
    return (total / BEAN_RATE).round();
  }

  static double countPrice(List<double> prices, int quantity,
      [double weight = 1]) {
    return 10000;
  }
}
