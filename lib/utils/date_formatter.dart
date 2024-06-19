import 'package:intl/intl.dart';

class DateFormatterUtil {
  static String formatedDateTimeFromString({String? date}) {
    if (date == null) return "";
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat("dd MMM y").format(dateTime);
  }

  static String formatedDateTimeFromDateTime({required DateTime date}) {
    return DateFormat("dd MMM y").format(date);
  }

  static String dateTimeToFormatedDateTime(String? dateTimeString) {
    if (dateTimeString == null) return "";

    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat("dd MMM y  h:mm a").format(dateTime);
  }
}
