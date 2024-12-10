import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

  static String formatToYMD(String time) {
    try {
      if(time == ""){
        return "";
      }
      DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(time);
      return DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime);
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

    if(!pathLocalOrServer(path)){
      return path;
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

  static Future<String> convertAttachmentToBase64(String path,String filename) async {
    if (path.isEmpty) {
      return '';
    }

    if(!pathLocalOrServer(path)){
      return path;
    }

    try {
      final file = File(path);
      // Periksa apakah file ada
      if (await file.exists()) {
        // Baca file menjadi byte array
        final fileBytes = await file.readAsBytes();
        debugPrint("print file ${filename}");
        if(filename.split(".").last == "pdf"){
          return base64Encode(fileBytes);
        }
        return 'data:image/png;base64,'+base64Encode(fileBytes);

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

  static String generateUniqueCode() {
    final now = DateTime.now();
    final timestamp = "${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}${now.millisecond}${now.microsecond}";
    return timestamp;
  }

  static String pathFile(String? path){
    try{
      if(path == null){
        return "";
      }
      if(path.contains("ops")){
        return path;
      }else{
        return '${baseUrl()}/storage/$path';
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

  static Future<void> deleteDatabaseFile(String pathDb) async {
    try {
      final file = File(pathDb);

      if (await file.exists()) {
        await file.delete(); // Menghapus file
      } else {
        print('File not found at: $pathDb');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}