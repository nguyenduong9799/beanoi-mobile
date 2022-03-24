String formatTime(String time) {
  String result = time.replaceAll(';', ' - ');
  return result;
}
