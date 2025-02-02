/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'transaction_list.g.dart';

@JsonSerializable()
class TransactionList extends ComFields {
  String memberId = "";
  String groupId = "";
  String trxType = "";
  late DateTime trxDt;
  String trxPeriod = "";
  double cr = 0;
  double dr = 0;
  String sourceType = "";
  String sourceId = "";
  String addedBy = "";
  String note = "";
  String id = "";
  late DateTime sysCreated;
  late DateTime sysUpdated;

  TransactionList({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.trxType,
    required this.trxPeriod,
    required this.cr,
    required this.dr,
    required this.sourceType,
    required this.sourceId,
    required this.addedBy,
    this.note = "",
    DateTime? trxDt,
    DateTime? sysCreated,
    DateTime? sysUpdated,
  }) {
    this.trxDt = trxDt ?? DateTime.now();
    this.sysCreated = sysCreated ?? DateTime.now();
    this.sysUpdated = sysUpdated ?? DateTime.now();
  }

  TransactionList.withEmpty() {
    trxDt = DateTime.now();
    sysCreated = DateTime.now();
    sysUpdated = DateTime.now();
    trxPeriod = AppUtils.getTrxPeriodFromDt(trxDt);
  }

  TransactionList.withDefault({
    required this.memberId,
    required this.groupId,
    required this.trxType,
    required this.trxPeriod,
    this.cr = 0,
    this.dr = 0,
    this.sourceId = "",
    this.sourceType = AppConstants.sUser,
    this.addedBy = "Admin",
    this.note = "",
    DateTime? trxDt,
    DateTime? sysCreated,
    DateTime? sysUpdated,
  }) {
    this.trxDt = trxDt ?? DateTime.now();
    sysCreated = DateTime.now();
    sysUpdated = DateTime.now();
  }

  factory TransactionList.fromJson(Map<String, dynamic> json) =>
      _$TransactionListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionListToJson(this);
}
