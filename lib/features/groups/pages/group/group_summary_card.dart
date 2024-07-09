/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/constants.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';

class GroupSummaryCard extends StatefulWidget {
  final List<GroupSummary> summary;
  final String viewMode;
  const GroupSummaryCard(
      {super.key, required this.summary, this.viewMode = "separate"});

  @override
  State<GroupSummaryCard> createState() => _GroupSummaryCardState();
}

class _GroupSummaryCardState extends State<GroupSummaryCard> {
  List<GroupSummary> summary = [];
  Map<String, double> creditSummaryMap = {};
  Map<String, double> totalSummaryMap = {};
  Map<String, double> debitSummaryMap = {};
  GroupSummary? opening;
  GroupSummary? closing;

  @override
  void initState() {
    summary = widget.summary;
    calculateSummary();
    super.initState();
  }

  void calculateSummary() {
    creditSummaryMap = {};
    debitSummaryMap = {};
    totalSummaryMap = {};
    for (var gs in summary) {
      var trxType = gs.trxType;
      if (gs.trxType == AppConstants.ttOpeningBalance) {
        opening = gs;
        continue;
      }
      if (gs.trxType == AppConstants.ttClosingBalance) {
        closing = gs;
        continue;
      }
      if (widget.viewMode == "total") {
        if (!totalSummaryMap.containsKey(trxType)) {
          totalSummaryMap[trxType] = 0;
        }
        var totalCr = gs.totalCr;
        var totalDr = gs.totalDr;
        var total = totalCr - totalDr;
        totalSummaryMap[trxType] = (totalSummaryMap[trxType] ?? 0) + total;
      } else if (widget.viewMode == "cr+dr") {
        var totalCr = gs.totalCr;
        var totalDr = gs.totalDr;

        if (totalCr > 0) {
          if (!creditSummaryMap.containsKey(trxType)) {
            creditSummaryMap[trxType] = 0;
          }
          creditSummaryMap[trxType] =
              (creditSummaryMap[trxType] ?? 0) + totalCr;
        }
        if (totalDr > 0) {
          if (!debitSummaryMap.containsKey(trxType)) {
            debitSummaryMap[trxType] = 0;
          }
          debitSummaryMap[trxType] = (debitSummaryMap[trxType] ?? 0) + totalDr;
        }
      }
    }
  }

  TableRow buildTableRow(String title, double amount, [String? subText]) {
    return TableRow(children: [
      TableCell(child: Text(title)),
      TableCell(
        child: Text(
          subText ?? amount.toStringAsFixed(2),
        ),
      )
    ]);
  }

  Table buildSummary() {
    List<TableRow> tableRows = [];
    if (opening != null && widget.viewMode != "balance") {
      GroupSummary o = opening!;
      tableRows.add(buildTableRow(o.trxType, o.totalCr - o.totalDr));
    }
    if (widget.viewMode == "total") {
      totalSummaryMap.forEach((key, value) {
        tableRows.add(buildTableRow(key, value));
      });
    } else if (widget.viewMode == "cr+dr") {
      creditSummaryMap.forEach((key, value) {
        tableRows.add(buildTableRow(key, value, "+$value"));
      });
      debitSummaryMap.forEach((key, value) {
        tableRows.add(buildTableRow(key, value, "-$value"));
      });
    }
    if (closing != null) {
      GroupSummary c = closing!;
      String cText = widget.viewMode == "balance" ? "Balance" : c.trxType;
      tableRows.add(buildTableRow(cText, c.totalCr - c.totalDr));
    }

    return Table(
      children: tableRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildSummary(),
    );
  }
}
