import 'dart:ffi';

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

  static String formatNumber(String? number){
    try{
      if(number == null ) return '';

      return double.parse(number).toInt().toString();
    } catch(e){
      return '';
    }
  }
}