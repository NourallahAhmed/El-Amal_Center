extension DateTimeAddCalendarDays on DateTime {
  /// Adds a specified number of days to this [DateTime].
  ///
  /// Unlike `DateTime.add(Duration(days: numberOfDays))`, this adds "days"
  /// and not 24-hour increments, and therefore it leaves the time of day
  /// unchanged if a DST change would occur during the time interval.
  DateTime addCalendarDays(int numDays) => copyWith(day: day + numDays);

  /// Copies a [DateTime], overriding specified values.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return (isUtc ? DateTime.utc : DateTime.new)(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}