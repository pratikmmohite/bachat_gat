/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../member/member_details_card.dart';

class AddMemberTransaction extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final DateTime trxPeriodDt;
  final Group group;
  final String mode;
  const AddMemberTransaction({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriodDt,
    required this.group,
    this.mode = AppConstants.tmPayment,
  });

  @override
  State<AddMemberTransaction> createState() => _AddMemberTransactionState();
}

class _AddMemberTransactionState extends State<AddMemberTransaction> {
  late GroupMemberDetails groupMemberDetail;
  late Group group;
  late GroupsDao groupDao;
  late DateTime trxPeriodDt;
  List<Loan> memberLoans = [];
  bool isLoading = false;
  bool isRecording = false;
  late Transaction shareTrx;
  late Transaction loanTrx;
  late Transaction loanInterestTrx;
  late Transaction lateFeeTrx;
  String? lastLoanInterestDate = "";
  @override
  void initState() {
    groupMemberDetail = widget.groupMemberDetail;
    trxPeriodDt = widget.trxPeriodDt;
    group = widget.group;
    groupDao = GroupsDao();
    prepareRequests();
    getLoans();
    getLastDate();
    super.initState();
  }

  Future<void> getLastDate() async {
    lastLoanInterestDate =
        await groupDao.getLastLoanInterestDate(groupMemberDetail);
  }

  Future<void> getLoans() async {
    memberLoans = [];
    var filter = MemberLoanFilter(group.id, groupMemberDetail.memberId);
    filter.status = AppConstants.lsActive;
    setState(() {
      isLoading = true;
    });
    try {
      memberLoans = await groupDao.getMemberLoans(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void prepareRequests() {
    var today = DateTime.now();
    shareTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttShare,
      sourceType: AppConstants.sUser,
      trxPeriod: AppUtils.getTrxPeriodFromDt(trxPeriodDt),
    );
    if (groupMemberDetail.paidShareAmount == 0) {
      shareTrx.cr = group.installmentAmtPerMonth;
    }
    loanTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLoan,
      sourceType: AppConstants.sLoan,
      trxPeriod: AppUtils.getTrxPeriodFromDt(trxPeriodDt),
      trxDt: today,
    );
    loanInterestTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLoanInterest,
      sourceType: AppConstants.sLoan,
      trxPeriod: AppUtils.getTrxPeriodFromDt(trxPeriodDt),
      trxDt: today,
    );
    lateFeeTrx = Transaction.withDefault(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      trxType: AppConstants.ttLateFee,
      sourceType: AppConstants.sUser,
      trxPeriod: AppUtils.getTrxPeriodFromDt(trxPeriodDt),
    );
  }

  Widget getFields() {
    switch (widget.mode) {
      case AppConstants.tmLoan:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            buildLoanOptions(),
            Table(
              children: [
                TableRow(
                  children: [
                    buildLoanField(),
                    buildLoanInterestField(),
                  ],
                ),
              ],
            ),
          ],
        );
      // break;
      case AppConstants.tmBoth:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    buildShareField(),
                    buildLateFeeField(),
                  ],
                ),
              ],
            ),
            const Divider(),
            const Text(
              "Record Loan Payment",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            buildLoanOptions(),
            Table(
              children: [
                TableRow(
                  children: [
                    buildLoanField(),
                    buildLoanInterestField(),
                  ],
                ),
              ],
            ),
          ],
        );
      // break;
      case AppConstants.tmPayment:
      default:
        return Table(
          children: [
            TableRow(
              children: [
                buildShareField(),
                buildLateFeeField(),
              ],
            )
          ],
        );
      // break;
    }
  }

  int CalculateMonthDifference(String startDateString, String endDateString) {
    if (startDateString == "") {
      return 1;
    }

    List<String> startParts = startDateString.split('-');
    int startYear = int.parse(startParts[0]);
    int startMonth = int.parse(startParts[1]);
    List<String> endParts = endDateString.split('-');
    int endYear = int.parse(endParts[0]);
    int endMonth = int.parse(endParts[1]);
    return (endYear * 12 + endMonth) - (startYear * 12 + startMonth);
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    print("IN the record transaction");
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abRecordTransaction),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppUtils.getTrxPeriodFromDt(trxPeriodDt),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: recordTransaction,
        label: Text("Record ${widget.mode}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MemberDetailsCard(
              groupMemberDetail: groupMemberDetail,
              trxPeriodDt: trxPeriodDt,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getFields(),
            ),
          ],
        ),
      ),
    );
  }

  bool isValid() {
    var local = AppLocal.of(context);
    switch (widget.mode) {
      case AppConstants.tmLoan:
        if (loanTrx.sourceId.isEmpty) {
          AppUtils.toast(context, local.mSelectLoan);
          return false;
        }
        if (loanTrx.cr == 0) {
          AppUtils.toast(context, local.mEnterLoanAmount);
          return false;
        }
        break;
      case AppConstants.tmPayment:
        if (shareTrx.cr == 0) {
          AppUtils.toast(context, local.mEnterShareAmount);
          return false;
        }
        break;
      case AppConstants.tmBoth:
        if (loanTrx.cr > 0) {
          if (loanTrx.sourceId.isEmpty) {
            AppUtils.toast(context, local.mSelectLoan);
            return false;
          }
        }
        if (shareTrx.cr > 0 ||
            loanTrx.cr > 0 ||
            loanInterestTrx.cr > 0 ||
            lateFeeTrx.cr > 0) {
          return true;
        }
        break;
    }
    return true;
  }

  void recordTransaction() async {
    if (isRecording) {
      AppUtils.toast(context, "Please wait operation in progress");
      return;
    }
    isRecording = true;
    try {
      if (!isValid()) {
        isRecording = false;
        return;
      }
      var local = AppLocal.of(context);
      switch (widget.mode) {
        case AppConstants.tmLoan:
          if (loanTrx.cr > 0) {
            await groupDao.addTransaction(loanTrx);
          }
          if (loanInterestTrx.cr > 0) {
            await groupDao.addTransaction(loanInterestTrx);
          }
          AppUtils.toast(context, local.mRecordedLoanPaymentSuccess);
          AppUtils.close(context);
          break;
        case AppConstants.tmPayment:
          if (shareTrx.cr > 0) {
            await groupDao.addTransaction(shareTrx);
          }
          if (lateFeeTrx.cr > 0) {
            await groupDao.addTransaction(lateFeeTrx);
          }
          AppUtils.toast(context, local.mRecordedSharePaymentSuccess);
          AppUtils.close(context);
          break;
        case AppConstants.tmBoth:
          if (shareTrx.cr > 0) {
            await groupDao.addTransaction(shareTrx);
          }
          if (lateFeeTrx.cr > 0) {
            await groupDao.addTransaction(lateFeeTrx);
          }
          if (loanTrx.cr > 0) {
            await groupDao.addTransaction(loanTrx);
          }
          if (loanInterestTrx.cr > 0) {
            await groupDao.addTransaction(loanInterestTrx);
          }
          AppUtils.toast(context, local.mRecordedSharePaymentSuccess);
          AppUtils.close(context);
          break;
      }
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    isRecording = false;
  }

  buildLoanField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      key: Key("lamt_${loanTrx.sourceId}"),
      label: local.tfLoanAmt,
      field: "loanAmount",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanTrx.cr ?? 0.0).toInt()}",
      onChange: (value) {
        loanTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanOptions() {
    var options = memberLoans
        .map(
          (e) => CustomDropDownOption<Loan>(e.toString(), e.id, e),
        )
        .toList();
    var local = AppLocal.of(context);
    return CustomDropDown<Loan>(
      label: local.tfSelectLoanToPay,
      value: loanTrx.sourceId,
      options: options,
      onChange: (op) {
        var remainingLoan = op.valueObj.loanAmount - op.valueObj.paidLoanAmount;
        var interest = op.valueObj.interestPercentage;
        var lastDate = AppUtils.getTrxPeriodFromDt(trxPeriodDt);
        var difference =
            CalculateMonthDifference(lastLoanInterestDate!, lastDate);
        setState(() {
          loanTrx.sourceId = op.value;
          loanInterestTrx.sourceId = op.value;
          loanInterestTrx.cr = double.parse(
              (remainingLoan * interest * difference / 100).toStringAsFixed(2));
        });
      },
    );
  }

  buildLateFeeField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      label: local.tfLateFee,
      field: "lateFee",
      value: "${(lateFeeTrx.cr ?? 0).toInt()}",
      suffixIcon: const Icon(Icons.currency_rupee),
      onChange: (value) {
        lateFeeTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanInterestField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      key: Key("lint_${loanTrx.sourceId}"),
      label: local.tfLoanInterest,
      field: "lateFee",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanInterestTrx.cr ?? 0)}",
      onChange: (value) {
        loanInterestTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }

  buildShareField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      label: local.tfShareAmount,
      field: "shareAmt",
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(shareTrx.cr ?? 0).toInt()}",
      onChange: (value) {
        shareTrx.cr = double.tryParse(value) ?? 0;
      },
    );
  }
}
