/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as desktopSqflite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart' as webSqflite;

import 'utils.dart';

class DbService {
  static final DbService _instance = DbService._internal();

  int version = 1;
  late sqlite.Database db;

  factory DbService() {
    return _instance;
  }

  DbService._internal();

  String get dbPath => db.path ?? "";

  void initDbFactory() {
    if (kIsWeb) {
      sqlite.databaseFactory = webSqflite.databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqlite.databaseFactory = desktopSqflite.databaseFactoryFfi;
      desktopSqflite.sqfliteFfiInit();
    }
  }

  Future<bool> initDb({String? path}) async {
    var dbPath = path ?? "app_db.sqlite";
    initDbFactory();
    db = await sqlite.openDatabase(dbPath, version: version,
        onCreate: (dbC, version) async {
      await _createTables(dbC);
    });
    return true;
  }

  Future<bool> closeDb() async {
    if (db.isOpen) {
      await db.close();
      return true;
    }
    return false;
  }

  Future<String> bkpDb() async {
    String dbPath = db.path;
    String bkpPath = "$dbPath.bkp";
    // Delete old backup
    await deleteDb(path: bkpPath);
    // Copy old db
    await AppUtils.copyFile(dbPath, bkpPath);
    return bkpPath;
  }

  Future<bool> deleteDb({String? path}) async {
    String dbPath = path ?? db.path;
    bool dbExist = await dbExists(dbPath);
    if (dbExist) {
      await sqlite.deleteDatabase(dbPath);
      return true;
    }
    return false;
  }

  Future<bool> dbExists(String path) async {
    return await sqlite.databaseExists(path);
  }

  Future<List<Map<String, Object?>>> read(String sql,
      [List<Object?> parameters = const []]) async {
    var res = await db.rawQuery(sql, parameters);
    return res;
  }

  Future<int> write(String sql, [List<Object?> parameters = const []]) async {
    var updatedRows = await db.rawUpdate(sql, parameters);
    return updatedRows;
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    var updatedRows = await db.insert(table, values);
    return updatedRows;
  }

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var updatedRows =
        await db.update(table, values, where: where, whereArgs: whereArgs);
    return updatedRows;
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var updatedRows =
        await db.delete(table, where: where, whereArgs: whereArgs);
    return updatedRows;
  }

  Future<String> getDbVersion() async {
    var res = await db.rawQuery("select sqlite_version() as version ");
    var dbVersion = res.first["version"].toString();
    var userVersion = await db.getVersion();
    return "DB Version: $dbVersion | Schema Version: $userVersion";
  }

  Future<void> _createTables(sqlite.Database dbC) async {
    List<String> tables = [
      '''
    CREATE TABLE groups (
      id text primary key,
      name text,
      sdt datetime,
      edt datetime,
      accountOpeningDate datetime,
      address text,
      bankName text,
      accountNo text,
      ifscCode text,
      installmentDate number,
      installmentAmtPerMonth number,
      loanInterestPercentPerMonth number,
      lateFeePerDay number,
      sysCreated datetime,
      sysUpdated datetime
    );
  ''',
      '''
    CREATE TABLE members (
      id text primary key,
      name text,
      mobileNo text,
      joiningDate datetime,
      groupId text,
      aadharNo text,
      panNo text,
      balance number,
      active_loan number,
      sysCreated datetime,
      sysUpdated datetime,
      FOREIGN KEY(groupId) REFERENCES groups(ID)
    );
  ''',
      '''
    create table transactions (
        id text primary key,
        groupId text,
        memberId text,
        trxPeriod text,
        trxDt datetime,
        trxType text,
        cr number,
        dr number,
        sourceType text,
        sourceId text,
        addedBy text,
        note text,
        sysCreated datetime,
        sysUpdated datetime,
        FOREIGN KEY(groupId) REFERENCES groups(id),
        FOREIGN KEY(memberId) REFERENCES members(id)
    )
  ''',
      '''
    CREATE TABLE loans (
      id text primary key,
      memberId text,
      groupId text,
      loanAmount number,
      interestPercentage number,
      paidLoanAmount number,
      paidInterestAmount number,
      note text,
      status text,
      addedBy text,
      loanDate datetime,
      sysCreated datetime,
      sysUpdated datetime,
      FOREIGN KEY(groupId) REFERENCES groups(id),
      FOREIGN KEY(memberId) REFERENCES members(id)
    );
  ''',
    ];
    for (int i = 0; i < tables.length; i++) {
      await dbC.execute(tables[i]);
    }
  }
}
