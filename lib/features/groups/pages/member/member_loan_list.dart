/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/member/member_details_card.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import '../transaction/add_loan_page.dart';

class MembersLoanList extends StatefulWidget {
  final Group group;
  final GroupMemberDetails groupMemberDetails;
  final DateTime trxPeriodDt;
  const MembersLoanList(this.group,
      {super.key, required this.groupMemberDetails, required this.trxPeriodDt});

  @override
  State<MembersLoanList> createState() => _MembersLoanListState();
}

class _MembersLoanListState extends State<MembersLoanList> {
  bool isLoading = false;

  List<Loan> loans = [];
  late GroupsDao groupDao;
  late Group _group;
  late GroupMemberDetails groupMemberDetails;
  late DateTime trxPeriodDt;

  Future<void> getMemberLoans() async {
    loans = [];
    setState(() {
      isLoading = true;
    });
    loans = await groupDao.getMemberLoans(MemberLoanFilter(
      groupMemberDetails.groupId,
      groupMemberDetails.memberId,
    ));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getGroupMembersDetails() async {
    var filter = MemberBalanceFilter(groupMemberDetails.groupId,
        AppUtils.getTrxPeriodFromDt(DateTime.now()));
    filter.memberId = groupMemberDetails.memberId;
    try {
      var res = await groupDao.getGroupMembersWithBalance(filter);
      if (res.isNotEmpty) {
        groupMemberDetails = res[0];
      }
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  void initState() {
    _group = widget.group;
    groupMemberDetails = widget.groupMemberDetails;
    trxPeriodDt = widget.trxPeriodDt;
    groupDao = GroupsDao();
    getMemberLoans();
    super.initState();
  }

  Future<void> deleteLoan(Loan loan) async {
    try {
      var res = await groupDao.deleteLoan(loan);
      getMemberLoans();
      getGroupMembersDetails();
      AppUtils.toast(context, "Loan deleted successfully");
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  Future<void> recalculateLoan(Loan loan) async {
    try {
      var res = await groupDao.recalculateLoanAmounts(loan.id);
      getMemberLoans();
      getGroupMembersDetails();
      AppUtils.toast(context, "Loan recalculated successfully");
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.abLoanList),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: MemberDetailsCard(
            groupMemberDetail: groupMemberDetails,
            trxPeriodDt: trxPeriodDt,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await AppUtils.navigateTo(
            context,
            AddLoanPage(
              groupMemberDetail: groupMemberDetails,
              trxPeriodDt: trxPeriodDt,
              group: _group,
            ),
          );
          await getGroupMembersDetails();
          await getMemberLoans();
        },
        icon: const Icon(Icons.add),
        label: Text(local.bAddLoan),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getGroupMembersDetails();
          await getMemberLoans();
        },
        child: ListView.builder(
          itemCount: loans.length,
          padding: const EdgeInsets.only(bottom: 300.0),
          itemBuilder: (ctx, index) {
            var loan = loans[index];
            var trxPeriod = AppUtils.getHumanReadableDt(loan.loanDate);
            return Card(
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trxPeriod,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      loan.status,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: loan.status == AppConstants.lsActive
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    OverflowBar(
                      children: [
                        IconButton(
                          onPressed: () {
                            recalculateLoan(loan);
                          },
                          icon: const Icon(Icons.calculate_sharp),
                        ),
                        CustomDeleteIcon<Loan>(
                          item: loan,
                          content: Text(
                              "Loan: ${AppUtils.getHumanReadableDt(loan.loanDate)} \nAmount ${loan.loanAmount}"),
                          onAccept: (l) {
                            deleteLoan(l);
                          },
                        ),
                      ],
                    )
                  ],
                ),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAmountChip(
                      label: local.tfLoanAmt,
                      amount: loan.loanAmount,
                      showInRow: true,
                    ),
                    CustomAmountChip(
                      label: "${local.lLoanInterest} (%)",
                      amount: loan.interestPercentage,
                      prefix: "",
                      showInRow: true,
                    ),
                    CustomAmountChip(
                      label: local.lPaidLoan,
                      amount: loan.paidLoanAmount,
                      showInRow: true,
                    ),
                    CustomAmountChip(
                      label: local.lPaidInterest,
                      amount: loan.paidInterestAmount,
                      showInRow: true,
                    ),
                    CustomAmountChip(
                      label: "Pending",
                      amount: loan.loanAmount - loan.paidLoanAmount,
                      showInRow: true,
                    ),
                    Text(
                      local.lNote,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(loan.note),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
