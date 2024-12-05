import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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

  static String pathFile(String? path){
    try{
      if(path == null){
        return "";
      }
      if(path.contains("ops")){
        return path;
      }else{
        return '${baseUrl()}/$path';
      }
    }catch(e){
      return '';
    }
  }

  static bool pathLocalOrServer(String? path){
    try{
      if(path == null){
        return false;
      }
      if(path.contains("ops")){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  static Future<bool> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult[0] == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult[0] == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}