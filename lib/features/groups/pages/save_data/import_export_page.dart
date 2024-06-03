/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'dart:io';

import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({super.key});

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  String dbVersion = "";

  Future<void> fetchDbVersion() async {
    var dbService = DbService();
    dbVersion = await dbService.getDbVersion();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> exportFile() async {
    try {
      var dbService = DbService();
      var dbFilePath = dbService.dbPath;
      var dt = DateTime.now();
      String fileName = "${dt.year}_${dt.month}_${dt.day}_bachat_db";
      AppUtils.toast(context, dbFilePath);
      print(dbFilePath);
      var x = await AppUtils.saveAsFile(fileName, dbFilePath);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  Future<void> importFile() async {
    try {
      var selectedFile = await AppUtils.pickFile(["sqlite"]);
      var bytes = await selectedFile?.readAsBytes();
      if (selectedFile == null ||
          bytes == null ||
          !AppUtils.isSQLiteFile(bytes)) {
        AppUtils.toast(context, "Select supported file with ext .sqlite");
        return;
      }
      var dbService = DbService();
      if (!kIsWeb) {
        await dbService.bkpDb();
      }
      await dbService.closeDb();
      await sqlite.databaseFactory.writeDatabaseBytes(dbService.dbPath, bytes);
      await dbService.initDb();
      AppUtils.toast(context, "Data imported successfully");
      AppUtils.close(context);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  File changeFileNameOnlySync(String oldFilePath, String newFileName) {
    var file = File(oldFilePath);
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.renameSync(newPath);
  }

  @override
  void initState() {
    super.initState();
    fetchDbVersion();
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abImportExport),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    importFile();
                  },
                  icon: const Icon(Icons.call_received),
                  label: Text(local.bImportFile),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    exportFile();
                  },
                  icon: const Icon(Icons.call_made_rounded),
                  label: Text(local.bExportFile),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: local.appTitle,
                      applicationVersion: AppConstants.version,
                      children: const [
                        Text("Developers: "),
                        Text("- Pratik Mohite <dev.pratikm@gmail.com>"),
                        Text("- Pranav Mohite <dev.pranav.mohite@gmail.com>"),
                        Text("Website: "),
                        Text("- https://pratikm.dev")
                      ],
                      applicationLegalese: "Copyright © 2024 pratikm.dev",
                      applicationIcon: Image.asset(
                        AppConstants.imgAppIcon,
                        height: 80,
                      ),
                    );
                  },
                  child: const Text("About & Licenses"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("App Version: ${AppConstants.version} | $dbVersion"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
