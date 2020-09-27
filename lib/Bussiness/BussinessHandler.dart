class BussinessHandler {
  static const double BEAN_RATE = 1000; // 1k VND = 1 bean

  static int beanReward(double total) {
    return (total / BEAN_RATE).round();
  }
}
