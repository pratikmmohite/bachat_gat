/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:json_annotation/json_annotation.dart';

import 'com_fields.dart';

part 'loan.g.dart';

@JsonSerializable()
class Loan extends ComFields {
  @override
  String id = "";
  String memberId = "";
  String groupId = "";
  double loanAmount = 0;
  double interestPercentage = 0;
  String status = "";
  String addedBy = "";
  DateTime loanDate = DateTime(2024, 1, 1);
  String note = "";
  double paidLoanAmount = 0;
  double paidInterestAmount = 0;
  @JsonKey(includeToJson: false)
  String? lastPaymentDate;

  Loan(
      {required this.memberId,
      required this.groupId,
      required this.loanAmount,
      required this.interestPercentage,
      required this.paidLoanAmount,
      required this.paidInterestAmount,
      required this.note,
      required this.status,
      required this.loanDate,
      required this.addedBy});
  Loan.withPayment(
    String loanId, {
    this.paidLoanAmount = 0,
    this.paidInterestAmount = 0,
  }) {
    id = loanId;
  }

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoanToJson(this);

  @override
  String toString() {
    return 'Loan: ₹$loanAmount, Paid:$paidLoanAmount\nDt: ${AppUtils.getHumanReadableDt(loanDate)}';
  }
}
