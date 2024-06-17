import 'package:intl/intl.dart';

class DateFormatterUtil {
  static String formatedDateTimeFromString({String? date}) {
    if (date == null) return "";
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat("dd MMM y").format(dateTime).toUpperCase();
  }

  static String formatedDateTimeFromDateTime({required DateTime date}) {
    return DateFormat("dd MMM y").format(date).toUpperCase();
  }
}
