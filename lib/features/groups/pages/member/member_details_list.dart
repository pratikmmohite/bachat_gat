/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/member/member_details_card.dart';
import 'package:bachat_gat/features/groups/pages/member/member_transactions_list.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/dao_index.dart';
import '../../models/models_index.dart';
import '../transaction/add_loan_page.dart';
import '../transaction/add_member_transaction.dart';
import 'member_loan_list.dart';

class MemberDetailsList extends StatefulWidget {
  final DateTime trxPeriodDt;
  final Group group;
  final String viewMode;
  const MemberDetailsList({
    super.key,
    required this.trxPeriodDt,
    required this.group,
    this.viewMode = "table",
  });

  @override
  State<MemberDetailsList> createState() => _MemberDetailsListState();
}

class _MemberDetailsListState extends State<MemberDetailsList> {
  late Group group;
  late DateTime trxPeriodDt;
  List<GroupMemberDetails> groupMemberDetails = [];
  late GroupsDao groupDao;
  bool isLoading = false;
  String viewMode = "table";

  Future<void> getGroupMembers() async {
    groupMemberDetails = [];
    var filter =
        MemberBalanceFilter(group.id, AppUtils.getTrxPeriodFromDt(trxPeriodDt));
    setState(() {
      isLoading = true;
    });
    try {
      groupMemberDetails = await groupDao.getGroupMembersWithBalance(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    groupDao = GroupsDao();
    group = widget.group;
    trxPeriodDt = widget.trxPeriodDt;
    viewMode = widget.viewMode;
    initDefault();
    getGroupMembers();
    super.initState();
  }

  Future<void> initDefault() async {
    viewMode = await StorageService.getViewMode(viewMode ?? "table");
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveViewMode() async {
    await StorageService.saveViewMode(viewMode);
  }

  Future<void> handleAddTrxClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddMemberTransaction(
        groupMemberDetail: memberDetails,
        trxPeriodDt: trxPeriodDt,
        group: group,
        mode: AppConstants.tmPayment,
      ),
    );
    getGroupMembers();
  }

  Future<void> handleBothTrxClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddMemberTransaction(
        groupMemberDetail: memberDetails,
        trxPeriodDt: trxPeriodDt,
        group: group,
        mode: AppConstants.tmBoth,
      ),
    );
    getGroupMembers();
  }

  Future<void> handleAddLoanTrxClick(GroupMemberDetails memberDetails) async {
    print("Loan inside");
    await AppUtils.navigateTo(
      context,
      AddMemberTransaction(
        groupMemberDetail: memberDetails,
        trxPeriodDt: trxPeriodDt,
        group: group,
        mode: AppConstants.tmLoan,
      ),
    );

    getGroupMembers();
  }

  Future<void> handleAddLoanClick(GroupMemberDetails memberDetails) async {
    await AppUtils.navigateTo(
      context,
      AddLoanPage(
        groupMemberDetail: memberDetails,
        trxPeriodDt: trxPeriodDt,
        group: group,
      ),
    );
    getGroupMembers();
  }

  DataCell buildCellS(String label, [GestureTapCallback? onTap]) {
    return DataCell(
      Text(label),
      onTap: onTap,
    );
  }

  DataCell buildCellI(Widget icon, [GestureTapCallback? onTap]) {
    return DataCell(
      icon,
      onTap: onTap,
    );
  }

  DataCell buildCellD(double label, [GestureTapCallback? onTap]) {
    return DataCell(
      Text("₹${label.toStringAsFixed(1)}"),
      onTap: onTap,
    );
  }

  Widget buildDetailsList() {
    return ListView.builder(
      itemCount: groupMemberDetails.length,
      padding: const EdgeInsets.only(bottom: 300.0),
      itemBuilder: (context, index) {
        var m = groupMemberDetails[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide(width: 0.1)),
          title: MemberDetailsCard(
            groupMemberDetail: m,
            trxPeriodDt: trxPeriodDt,
          ),
          subtitle: buildActions(m),
        );
      },
    );
  }

  Widget buildDetailsTable() {
    var local = AppLocal.of(context);
    List<String> columns = [
      local.lMember,
      local.lShare,
      local.lLoan,
      local.lInterest,
      local.lPenalty,
      local.lOthers,
      local.lTotal,
      local.lGivenLoan,
      local.lRmLoan,
      local.lActions,
    ];
    List<DataRow> rows = groupMemberDetails
        .map(
          (m) => DataRow(
            cells: [
              buildCellS(m.name),
              buildCellD(m.paidShareAmount, () => handleAddTrxClick(m)),
              buildCellD(m.paidLoanAmount, () => handleAddLoanTrxClick(m)),
              buildCellD(m.paidLoanInterestAmount),
              buildCellD(m.paidLateFee),
              buildCellD(m.paidOtherAmount),
              buildCellD(m.paidLoanAmount +
                  m.paidLoanInterestAmount +
                  m.paidShareAmount +
                  m.paidLateFee +
                  m.paidOtherAmount),
              buildCellD(m.lendLoan, () => handleShowLoanClick(m)),
              buildCellD(m.pendingLoanAmount, () => handleShowLoanClick(m)),
              buildCellI(buildActions(m)),
            ],
          ),
        )
        .toList();
    var summary = getSummaryRow();
    rows.add(summary);
    return DataTable(
      showBottomBorder: true,
      columnSpacing: 25,
      columns: columns
          .map(
            (e) => DataColumn(
              label: Text(
                e,
              ),
            ),
          )
          .toList(),
      rows: rows,
    );
  }

  DataRow getSummaryRow() {
    double totalBalance = 0;
    double totalPaidShareAmount = 0;
    double totalPaidLoanAmount = 0;
    double totalLendLoanAmount = 0;
    double totalPaidLateFee = 0;
    double totalPendingLoanAmount = 0;
    double totalPaidLoanInterestAmount = 0;
    double totalPaidOtherAmount = 0;
    for (var m in groupMemberDetails) {
      totalBalance += m.balance;
      totalPaidShareAmount += m.paidShareAmount;
      totalPaidLoanAmount += m.paidLoanAmount;
      totalLendLoanAmount += m.lendLoan;
      totalPaidLateFee += m.paidLateFee;
      totalPendingLoanAmount += m.pendingLoanAmount;
      totalPaidLoanInterestAmount += m.paidLoanInterestAmount;
      totalPaidOtherAmount += m.paidOtherAmount;
    }

    return DataRow(
      cells: [
        buildCellS("Total"),
        buildCellD(totalPaidShareAmount),
        buildCellD(totalPaidLoanAmount),
        buildCellD(totalPaidLoanInterestAmount),
        buildCellD(totalPaidLateFee),
        buildCellD(totalPaidOtherAmount),
        buildCellD(totalPaidShareAmount +
            totalPaidLoanAmount +
            totalPaidLoanInterestAmount +
            totalPaidLateFee +
            totalPaidOtherAmount),
        buildCellD(totalLendLoanAmount),
        buildCellD(totalPendingLoanAmount),
        buildCellS(""),
      ],
    );
  }

  Widget buildView() {
    var locale = AppLocal.of(context);
    if (groupMemberDetails.isEmpty) {
      return Center(
        child: Text(
          locale.mEmptyMemberDetails,
        ),
      );
    }
    if (viewMode == "list") {
      return buildDetailsList();
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 300.0),
          child: buildDetailsTable(),
        ),
      ),
    );
  }

  Widget buildActions(GroupMemberDetails m) {
    var local = AppLocal.of(context);
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonPadding: const EdgeInsets.all(0),
      children: [
        IconButton(
          onPressed: () => handleBothTrxClick(m),
          icon: const Icon(Icons.receipt_long_outlined),
          tooltip: local.bAddShare,
        ),
        // IconButton(
        //   onPressed: () => handleAddLoanTrxClick(m),
        //   icon: const Icon(Icons.add_shopping_cart),
        //   tooltip: local.bAddLoan,
        // ),
        IconButton(
          onPressed: () => handleShowLoanClick(m),
          icon: const Icon(Icons.account_balance_outlined),
          tooltip: local.bShowLoans,
        ),
        IconButton(
          onPressed: () => handleShowTransactionListClick(m),
          icon: const Icon(Icons.remove_red_eye_outlined),
          tooltip: local.bShowTransactions,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (viewMode) {
            case "table":
              viewMode = "list";
              break;
            case "list":
              viewMode = "table";
              break;
          }
          saveViewMode();
          setState(() {});
        },
        child: const Icon(Icons.view_agenda_outlined),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await getGroupMembers();
              },
              child: buildView(),
            ),
    );
  }

  handleShowLoanClick(GroupMemberDetails m) async {
    await AppUtils.navigateTo(
      context,
      MembersLoanList(
        group,
        groupMemberDetails: m,
        trxPeriodDt: trxPeriodDt,
      ),
    );
    getGroupMembers();
  }

  handleShowTransactionListClick(GroupMemberDetails m) async {
    await AppUtils.navigateTo(
      context,
      MemberTransactionsList(
        group,
        groupMemberDetails: m,
        trxPeriodDt: trxPeriodDt,
      ),
    );
    getGroupMembers();
  }
}
