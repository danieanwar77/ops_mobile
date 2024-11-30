import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

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

  static String formatToHourMinuteFromDate(String time) {
    try {
      DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(time);
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

  static Future<String> convertPhotosToBase64(String path) async {
    if (path.isEmpty) {
      return '';
    }

    try {
      final file = File(path);
      // Periksa apakah file ada
      if (await file.exists()) {
        // Baca file menjadi byte array
        final fileBytes = await file.readAsBytes();

        // Konversi byte array ke base64
        return base64Encode(fileBytes);
      } else {
        // Jika file tidak ditemukan, kembalikan string kosong
        return '';
      }
    } catch (e) {
      // Tangani error dengan mengembalikan string kosong
      return '';
    }
  }

  static String baseUrl(){
    try{
      return 'https://tbi-ops-dev.intishaka.com';
    }catch(e){
      return '';
    }
  }
}