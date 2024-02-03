import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/features/groups/pages/member/member_details_card.dart';
import 'package:flutter/material.dart';

import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';
import '../transaction/add_loan_page.dart';

class MembersLoanList extends StatefulWidget {
  final Group group;
  final GroupMemberDetails groupMemberDetails;
  const MembersLoanList(this.group,
      {super.key, required this.groupMemberDetails});

  @override
  State<MembersLoanList> createState() => _MembersLoanListState();
}

class _MembersLoanListState extends State<MembersLoanList> {
  bool isLoading = false;
  List<Loan> loans = [];
  late GroupsDao groupDao;
  late Group _group;
  late GroupMemberDetails groupMemberDetails;

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
    groupDao = GroupsDao();
    getMemberLoans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: MemberDetailsCard(groupMemberDetails),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AppUtils.navigateTo(
            context,
            AddLoanPage(
              groupMemberDetail: groupMemberDetails,
              trxPeriod: "",
              group: _group,
            ),
          );
          await getGroupMembersDetails();
          await getMemberLoans();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getMemberLoans();
        },
        child: ListView.builder(
          itemCount: loans.length,
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
                  ],
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      children: [
                        TableRow(
                          children: [
                            CustomAmountChip(
                              label: "Loan Amount",
                              amount: loan.loanAmount,
                              showInRow: true,
                            ),
                            CustomAmountChip(
                              label: "Interest (%)",
                              amount: loan.interestPercentage,
                              prefix: "",
                              showInRow: true,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            CustomAmountChip(
                              label: "Paid Loan",
                              amount: loan.paidLoanAmount,
                              showInRow: true,
                            ),
                            CustomAmountChip(
                              label: "Paid Interest",
                              amount: loan.paidInterestAmount,
                              showInRow: true,
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: RichText(
                        text: TextSpan(
                          text: "Note : ",
                          children: [TextSpan(text: loan.note)],
                        ),
                      ),
                    )
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