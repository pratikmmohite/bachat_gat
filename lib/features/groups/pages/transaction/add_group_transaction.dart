/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/dao/dao_index.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class AddGroupTransaction extends StatefulWidget {
  final Group group;
  const AddGroupTransaction({super.key, required this.group});

  @override
  State<AddGroupTransaction> createState() => _AddGroupTransactionState();
}

class _AddGroupTransactionState extends State<AddGroupTransaction> {
  late Transaction trx;
  late Group group;
  late GroupsDao groupDao;
  void prepareTransactionRequest() {
    trx = Transaction.withEmpty();
    trx.groupId = group.id;
    trx.memberId = "";
    trx.trxType = AppConstants.ttBankInterest;
    trx.cr = 0;
    trx.dr = 0;
    trx.sourceType = AppConstants.sUser;
    trx.sourceId = "";
    trx.addedBy = "Admin";
    trx.note = "";
  }

  @override
  void initState() {
    group = widget.group;
    groupDao = GroupsDao();
    prepareTransactionRequest();
    super.initState();
  }

  bool isValid() {
    switch (trx.trxType) {
      case AppConstants.ttExpenditures:
        if (trx.cr == 0) {
          return false;
        }
        break;
      case AppConstants.ttBankInterest:
        if (trx.dr == 0) {
          return false;
        }
        break;
    }
    return true;
  }

  Future<void> addTransaction() async {
    try {
       await groupDao.addTransaction(trx);
      AppUtils.toast(context, "Transaction Recorded Successfully");
      AppUtils.close(context);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addTransaction();
        },
        label: const Text("Save"),
        icon: const Icon(
          Icons.add,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomDropDown<String>(
              label: "Select Transaction Type",
              options: AppConstants.otherTrxTypeOptions,
              onChange: (t) {
                setState(() {
                  trx.trxType = t.value;
                  trx.cr = trx.dr = 0;
                });
              },
              value: trx.trxType,
            ),
            CustomDateField(
              label: "Date",
              field: "trxDt",
              value: trx.trxDt,
              futureDataDisable: false,
              onChange: (dt) {
                setState(() {
                  trx.trxDt = dt;
                  trx.trxPeriod = AppUtils.getTrxPeriodFromDt(dt);
                });
              },
            ),
            if (AppConstants.uiCrGroupTrxTypes.contains(trx.trxType))
              CustomTextField(
                label: "Enter Amount",
                field: "cr",
                keyboardType: TextInputType.number,
                value: "${trx.cr}",
                onChange: (val) {
                  trx.cr = double.tryParse(val) ?? 0;
                },
              ),
            if (AppConstants.uidrGroupTrxTypes.contains(trx.trxType))
              CustomTextField(
                label: "Enter Amount",
                field: "dr",
                keyboardType: TextInputType.number,
                value: "${trx.dr}",
                onChange: (val) {
                  trx.dr = double.tryParse(val) ?? 0;
                },
              ),
            CustomTextField(
              label: "Note",
              field: "note",
              value: trx.note,
              onChange: (val) {
                trx.note = val;
              },
            ),
          ],
        ),
      ),
    );
  }
}
