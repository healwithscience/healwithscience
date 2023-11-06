extension DateTimeUtils on DateTime {
  List<DateTime> get currentWeekDays {
    return List.generate(
      7,
      (i) => subtract(Duration(days: weekday - 1)).add(
        Duration(days: i),
      ),
    );
  }
}


