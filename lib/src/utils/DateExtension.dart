extension DateTimeExtension on DateTime {
  DateTime copyWithHMS(int hour, int minute, int second) {
    return DateTime(this.year, this.month, this.day, hour, minute, second);
  }

  bool isSameDayAs(DateTime dateTime) {
    if (dateTime == null) {
      return false;
    }
    return dateTime.day == this.day &&
        dateTime.month == this.month &&
        dateTime.year == this.year;
  }

  bool isWeekend() {
    return this.weekday == DateTime.saturday || this.weekday == DateTime.sunday;
  }

  bool isSameMonthAs(DateTime dateTime) {
    if (dateTime == null) {
      return false;
    }
    return dateTime.month == this.month && dateTime.year == this.year;
  }

  bool get isToday {
    return this.isSameDayAs(DateTime.now());
  }
}
