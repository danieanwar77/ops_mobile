import 'package:intl/intl.dart';

class Helper {
  /// Formats a time string from 'HH:mm:ss' to 'HH:mm'.
  static String formatToHourMinute(String time) {
    try {
      DateTime dateTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("HH:mm").format(dateTime);
    } catch (e) {
      // Handle any parsing errors
      return time; // Return the original time if parsing fails
    }
  }
}