/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

import 'constants.dart';

class AppUtils {
  static var uuid = const Uuid();
  static String getUUID() {
    return uuid.v1();
  }

  static void toast(BuildContext context, String msg) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  static Future<void> navigateTo(BuildContext context, Widget navToWid) async {
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ct) => navToWid,
      ),
    );
  }

  static void close(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  static String getTrxPeriodFromDt(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, "0")}";
  }

  static String getHumanReadableDt(DateTime dt) {
    return "${dt.day}-${AppConstants.cEnMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getHumanReadableMonthDt(DateTime dt) {
    return "${AppConstants.cEnMonthsStr[dt.month - 1]} ${dt.year}";
  }

  static String getReadableTrxPeriod(DateTime dt) {
    return "${dt.day}-${AppConstants.cEnMonthsStr[dt.month - 1]}-${dt.year}";
  }

  static String getTrxPeriod(int month, int year) {
    return "$year-${AppConstants.cEnMonthsStr[month - 1]}";
  }

  static List<String> getMonthStringsFromDate(DateTime startDate) {
    List<String> monthStrings = [];

    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;

    int startYear = startDate.year;
    int startMonth = startDate.month;

    while (startYear < currentYear ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      String monthYearString = getTrxPeriod(startMonth, startYear);
      monthStrings.add(monthYearString);

      startMonth++;
      if (startMonth > 12) {
        startMonth = 1;
        startYear++;
      }
    }

    return monthStrings;
  }

  static List<DateTime> getMonthsFromStartToEndDt(
      DateTime startDate, DateTime endDate,
      [bool noFuture = false]) {
    List<DateTime> monthStrings = [];
    if (noFuture) {
      var today = DateTime.now();
      if (endDate.year >= today.year && endDate.month >= today.month) {
        endDate = today;
      }
    }
    int currentYear = endDate.year;
    int currentMonth = endDate.month;

    int startDay = startDate.day;
    int startYear = startDate.year;
    int startMonth = startDate.month;

    while (startYear < currentYear ||
        (startYear == currentYear && startMonth <= currentMonth)) {
      monthStrings.add(DateTime(startYear, startMonth, startDay));
      startMonth++;
      if (startMonth > 12) {
        startMonth = 1;
        startYear++;
      }
    }

    return monthStrings;
  }

  static Future<String?> saveAsFile(String name, String filePath) async {
    String ext = filePath.split(".").last;
    var path = await FileSaver.instance.saveAs(
        filePath: filePath, name: name, ext: ext, mimeType: MimeType.other);
    return path;
  }

  static Future<String?> saveAsBytes(
    String name,
    String ext,
    Uint8List bytes,
  ) async {
    var path = await FileSaver.instance
        .saveAs(bytes: bytes, name: name, ext: ext, mimeType: MimeType.other);
    return path;
  }

  static saveAndOpenFile(List<int> bytes, {String ext = "xlsx"}) async {
    var directory = await getTempDirectory();

    var id = "x${AppUtils.getUUID()}";
    String filePath = [directory, "$id.$ext"].join(Platform.pathSeparator);

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    OpenFilex.open(filePath);
  }

  static Future<String> pickFilePath([List<String>? allowedExtensions]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [],
      allowMultiple: false,
      type: FileType.any,
    );
    if (result != null) {
      return result.files.single.path!;
    }
    return "";
  }

  static Future<XFile?> pickFile([List<String>? allowedExtensions]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: [],
      allowMultiple: false,
      withData: true,
      type: FileType.any,
    );
    if (result != null) {
      return result.xFiles.first;
    }
    return null;
  }

  static Future<bool> renameFile(String path, String renamePath) async {
    var file = File(path);
    if (file.existsSync()) {
      await file.rename(path);
      return true;
    }
    return false;
  }

  static Future<bool> copyFile(String path, String renamePath) async {
    var file = File(path);
    if (file.existsSync()) {
      await file.copy(renamePath);
      return true;
    }
    return false;
  }

  static Future<String> getDocumentDirectory() async {
    final directory = await path.getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> getTempDirectory() async {
    final directory = await path.getTemporaryDirectory();
    return directory.path;
  }

  static bool isSQLiteFile(Uint8List? fileBytes) {
    try {
      if (fileBytes == null || fileBytes.length < 16) {
        return false;
      }
      // Read the first 16 bytes of the file
      List<int> bytes = fileBytes.sublist(0, 16);
      // SQLite databases start with the ASCII string "SQLite format 3"
      String signature = String.fromCharCodes(bytes);
      bool res = signature.contains("SQLite format 3");
      return res;
    } catch (e) {
      // Error reading the file or file is too small
      return false;
    }
  }
}
