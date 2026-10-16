extension WeekUtils on DateTime {
  DateTime get weekStart {
    final date = copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    return date.subtract(Duration(days: date.weekday - 1));
  }
}
