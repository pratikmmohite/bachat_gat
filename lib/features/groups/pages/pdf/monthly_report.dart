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

class MonthlyReport extends StatefulWidget {
  const MonthlyReport(this.group, {super.key});
  final Group group;

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  late Group _group;
  bool selectedDate = false;

  // double previousRemaining = 0.0;
  String str = "";
  String end = "";
  late String trxPeriod;

  DateTime _startDate = DateTime.now();
  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  late CalculatedMonthlySummary monthlySummary = CalculatedMonthlySummary(
    MonthlyBalanceSummary(
      totalDeposit: 0.0,
      totalShares: 0.0,
      totalLoanInterest: 0.0,
      totalPenalty: 0.0,
      otherDeposit: 0.0,
      totalExpenditures: 0.0,
      remainingLoan: 0.0,
      paidLoan: 0.0,
      givenLoan: 0.0,
      peviousRemainigBalance: 0.0,
    ),
  );

  late GroupsDao dao;
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  late TextEditingController _textController =
      TextEditingController(text: formatDt(_startDate));
  @override
  void initState() {
    super.initState();
    _group = widget.group;
    // previousRemaining = 0.0;
    dao = GroupsDao();

    trxPeriod = _formatDate(_startDate);
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lMReport),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Month",
                  hintText: "Enter ${local.tfStartDate}",
                  filled: true,
                ),
                controller: _textController,
                onTap: () async {
                  DateTime? selectedRange = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2099),
                    initialEntryMode: DatePickerEntryMode.input,
                  );
                  if (selectedRange != null) {
                    setState(() {
                      _startDate = selectedRange;
                      trxPeriod = _formatDate(_startDate);
                      str = local.getHumanTrxPeriod(_startDate);
                      _textController.text = formatDt(selectedRange);
                    });
                  }
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  CalculatedMonthlySummary summary =
                      await dao.getMonthlySummary(
                    _group.id.toString(),
                    trxPeriod,
                  );

                  setState(() {
                    monthlySummary = summary;
                  });
                },
                label: const Text('Refresh'),
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: true,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${local.tfGroupName} : ${_group.name.toString()}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${local.period} : ${AppUtils.getHumanReadableMonthDt(_startDate)} ',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lPrm),
                            Text(
                              monthlySummary.previousRemainingBalance
                                  .toStringAsFixed(2),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lDeposit),
                            Text(
                              monthlySummary.totalDeposit.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.ltShares),
                            Text(
                              monthlySummary.totalShares.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lPaidLoan),
                            Text(
                              monthlySummary.paidLoan.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lPaidInterest),
                            Text(
                              monthlySummary.loanInterest.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lPenalty),
                            Text(
                              monthlySummary.totalPenalty.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.ltOther),
                            Text(
                              monthlySummary.totalOtherDeposit
                                  .toStringAsFixed(2),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              local.lmcr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              monthlySummary.monthlyCredit.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              local.ltcr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              monthlySummary.totalCredit.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.lGivenLoan + "(-)"),
                            Text(
                              monthlySummary.givenLoan.toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(local.ltExpenditures + "(-)"),
                            Text(
                              monthlySummary.totalExpenditures
                                  .toStringAsFixed(2),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              local.ltdr + "(-)",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              monthlySummary.totalDebit.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              local.lcb,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              monthlySummary.monthlyClosingBalance
                                  .toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " ${local.lTotal}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              monthlySummary.total.toStringAsFixed(2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
