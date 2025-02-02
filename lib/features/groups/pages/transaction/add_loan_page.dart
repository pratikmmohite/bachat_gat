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

class AddLoanPage extends StatefulWidget {
  final GroupMemberDetails groupMemberDetail;
  final DateTime trxPeriodDt;
  final Group group;
  const AddLoanPage({
    super.key,
    required this.groupMemberDetail,
    required this.trxPeriodDt,
    required this.group,
  });

  @override
  State<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> {
  late GroupMemberDetails groupMemberDetail;
  late Group group;
  late GroupsDao groupDao;
  late DateTime trxPeriodDt;
  List<Loan> memberLoans = [];
  bool isLoading = false;
  late Loan loanTrx;

  @override
  void initState() {
    groupDao = GroupsDao();
    groupMemberDetail = widget.groupMemberDetail;
    trxPeriodDt = widget.trxPeriodDt;
    group = widget.group;
    prepareRequests();
    super.initState();
  }

  void prepareRequests() {
    loanTrx = Loan(
      memberId: groupMemberDetail.memberId,
      groupId: groupMemberDetail.groupId,
      loanAmount: 0,
      interestPercentage: group.loanInterestPercentPerMonth,
      paidLoanAmount: 0,
      paidInterestAmount: 0,
      status: AppConstants.lsActive,
      loanDate: trxPeriodDt,
      note: '',
      addedBy: 'Admin',
    );
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abAddLoan),
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
        onPressed: () async {
          try {
            if (loanTrx.loanAmount > 0) {
              await groupDao.addLoan(loanTrx);
              AppUtils.toast(context, local.mLoanSuccess);
              AppUtils.close(context);
              return;
            }
          } catch (e) {
            AppUtils.toast(context, e.toString());
          }
        },
        label: Text(local.bGiveLoan),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              MemberDetailsCard(
                groupMemberDetail: groupMemberDetail,
                trxPeriodDt: trxPeriodDt,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      buildLoanField(),
                      buildLoanInterestField(),
                    ],
                  )
                ],
              ),
              buildNoteField(),
            ],
          ),
        ),
      ),
    );
  }

  buildLoanField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      label: local.tfEnterLoanAmt,
      field: "loanAmount",
      keyboardType: TextInputType.number,
      suffixIcon: const Icon(Icons.currency_rupee),
      value: "${(loanTrx.loanAmount ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.loanAmount = double.tryParse(value) ?? 0;
      },
    );
  }

  buildLoanInterestField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      label: local.tfEnterLoanInterest,
      field: "loanAmount",
      keyboardType: TextInputType.number,
      suffixIcon: const Icon(Icons.percent),
      value: "${(loanTrx.interestPercentage ?? 0).toInt()}",
      onChange: (value) {
        loanTrx.interestPercentage = double.tryParse(value) ?? 0;
      },
    );
  }

  buildNoteField() {
    var local = AppLocal.of(context);
    return CustomTextField(
      label: local.tfEnterNote,
      field: "note",
      value: loanTrx.note,
      onChange: (value) {
        loanTrx.note = value;
      },
    );
  }
}
