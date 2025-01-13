extension DateExtension on DateTime {
  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  String toDateString() {
    return '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}/$year';
  }

  static DateTime stringToDate(String date) {
    final parts = date.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
