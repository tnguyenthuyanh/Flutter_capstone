class EnhancedDateTime {
  late DateTime _dateTime;
  late int month;
  late String monthString;

  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  DateTime get dateTime => _dateTime;

  EnhancedDateTime({required dateTime}) {
    _dateTime = dateTime;
    month = dateTime.month;
    monthString = getMonthString(month);
  }

  static EnhancedDateTime getEndDate(DateTime date) {
    EnhancedDateTime temp = EnhancedDateTime(dateTime: date);
    temp.setAsEndDate();
    return temp;
  }

  static EnhancedDateTime getStartDate(DateTime date) {
    EnhancedDateTime temp = EnhancedDateTime(dateTime: date);
    temp.setAsStartDate();
    return temp;
  }

  void setAsStartDate() {
    _dateTime = getBeginningOfMonth(_dateTime);
    _dateTime = getEarliestTime(_dateTime);
  }

  void setAsEndDate() {
    _dateTime = getEndOfMonth(_dateTime);
    _dateTime = getLatestTime(_dateTime);
  }

  DateTime getBeginningOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1, 0, 01, 01, 01);
  }

  DateTime getEndOfMonth(DateTime dateTime) {
    int newDay = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    return DateTime(dateTime.year, dateTime.month, newDay, 23, 59, 59, 59);
  }

  DateTime getEarliestTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 01, 01, 01);
  }

  DateTime getLatestTime(DateTime dateTime) {
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 59);
  }

  static String getMonthString(int month) {
    return months[month - 1];
  }
}
