/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/features/groups/models/models_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../../../common/common_index.dart';
import '../../dao/dao_index.dart';
import 'group_summary_card.dart';

class GroupMonthlySummary extends StatefulWidget {
  final Group group;
  const GroupMonthlySummary({super.key, required this.group});

  @override
  State<GroupMonthlySummary> createState() => _GroupMonthlySummaryState();
}

class _GroupMonthlySummaryState extends State<GroupMonthlySummary> {
  late Group group;
  late GroupsDao groupDao;
  var filter = GroupSummaryFilter();
  List<GroupSummary> groupSummary = [];
  bool isLoading = false;

  @override
  void initState() {
    group = widget.group;
    groupDao = GroupsDao();
    filter = GroupSummaryFilter(group.id);
    filter.sdt = group.sdt;
    filter.edt = group.edt;
    getGroupSummary();
    super.initState();
  }

  Future<void> getGroupSummary() async {
    groupSummary = [];
    setState(() {
      isLoading = true;
    });
    try {
      groupSummary = await groupDao.getGroupSummary(filter);
    } catch (e) {
      AppUtils.toast(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildSummaryDetails(local) {
    var columns = [
      DataColumn(
        label: Text(local.period),
      ),
      DataColumn(
        label: Text(local.type),
      ),
      DataColumn(
        label: Text(local.ltcr),
      ),
      DataColumn(
        label: Text(local.ltdr),
      ),
    ];
    List<DataRow> rows = groupSummary.map(
      (e) {
        var totalCr = e.totalCr;
        var totalDr = e.totalDr;
        if (e.trxType == AppConstants.ttOpeningBalance ||
            e.trxType == AppConstants.ttClosingBalance) {
          totalCr = (e.totalCr - e.totalDr);
          totalDr = 0;
        }

        return DataRow(
          cells: [
            DataCell(
              Text(e.trxPeriod),
            ),
            DataCell(
              Text(e.trxType),
            ),
            DataCell(
              Text(totalCr.toStringAsFixed(2)),
            ),
            DataCell(
              Text(totalDr.toStringAsFixed(2)),
            )
          ],
        );
      },
    ).toList();
    double width = MediaQuery.of(context).size.width / columns.length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: DataTable(columns: columns, rows: rows),
      ),
    );
    // return DataTable(columnSpacing: width, columns: columns, rows: rows);
  }

  void dateRangePickup() async {
    var dtRng = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: filter.sdt, end: filter.edt),
      firstDate: DateTime(2010),
      lastDate: DateTime(2099),
    );
    if (dtRng != null) {
      filter.sdt = dtRng.start;
      filter.edt = dtRng.end;
      getGroupSummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lgSummary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: InkWell(
            onTap: () {
              dateRangePickup();
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppUtils.getHumanReadableDt(filter.sdt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.indigo,
                  ),
                ),
                Text(local.to),
                Text(
                  AppUtils.getHumanReadableDt(filter.edt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              dateRangePickup();
            },
            icon: const Icon(
              Icons.date_range,
            ),
          )
        ],
      ),
      bottomSheet: ExpansionTile(
        title: Text(local.sumr),
        initiallyExpanded: false,
        children: [
          GroupSummaryCard(
            key: Key("gs_${groupSummary.length}"),
            summary: groupSummary,
            viewMode: "cr+dr",
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getGroupSummary();
        },
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 300.0),
                    child: buildSummaryDetails(local),
                  ),
                ),
              ),
      ),
    );
  }
}
