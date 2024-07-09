/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'loans.g.dart';

@JsonSerializable()
class LoansList extends ComFields {
  String id = "";
  String memberId = "";
  String groupId = "";
  double loanAmount = 0.0;
  double interestPercentage = 0.0;
  double paidLoanAmount = 0.0;
  double paidInterestAmount = 0.0;
  String note = "";
  String status = "";
  String addedBy = "";
  DateTime loanDate = DateTime(2024, 1, 1);
  late DateTime sysCreated;
  late DateTime sysUpdated;

  LoansList({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.loanAmount,
    required this.interestPercentage,
    required this.paidLoanAmount,
    required this.paidInterestAmount,
    required this.status,
    required this.addedBy,
    this.note = "",
    DateTime? loanDate,
    DateTime? sysCreated,
    DateTime? sysUpdated,
  }) {
    this.loanDate = loanDate ?? DateTime.now();
    this.sysCreated = sysCreated ?? DateTime.now();
    this.sysUpdated = sysUpdated ?? DateTime.now();
  }

  LoansList.withEmpty() {
    loanDate = DateTime.now();
    sysCreated = DateTime.now();
    sysUpdated = DateTime.now();
  }

  LoansList.withDefault({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.loanAmount,
    required this.interestPercentage,
    required this.paidInterestAmount,
    required this.status,
    this.addedBy = "Admin",
    this.note = "",
    DateTime? laonDate,
    DateTime? sysCreated,
    DateTime? sysUpdated,
  }) {
    this.loanDate = loanDate ?? DateTime.now();
    sysCreated = DateTime.now();
    sysUpdated = DateTime.now();
  }

  factory LoansList.fromJson(Map<String, dynamic> json) =>
      _$LoansListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoansListToJson(this);
}
