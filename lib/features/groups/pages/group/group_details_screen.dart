/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/utils.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import '../member/member_details_list.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Group group;
  const GroupDetailsScreen({super.key, required this.group});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Group group;
  List<DateTime> tabMonths = [];
  List<Tab> tabs = [];
  // YYYY-MM
  late DateTime selectedTrxPeriodDt;
  TabController? tabController;
  @override
  void initState() {
    group = widget.group;
    buildMonths();
    super.initState();
  }

  void buildMonths() {
    tabs = [];
    var dt = DateTime.now();
    tabMonths = AppUtils.getMonthsFromStartToEndDt(group.sdt, dt, true);
    var initialIndex = tabMonths.indexWhere(
      (element) => element.year == dt.year && element.month == dt.month,
    );
    selectedTrxPeriodDt = tabMonths[initialIndex];
    initialIndex = initialIndex >= 0 ? initialIndex : 0;
    tabController = TabController(
      length: tabMonths.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    tabController?.addListener(() {
      setState(() {
        selectedTrxPeriodDt = tabMonths[tabController?.index ?? 0];
      });
    });
  }

  List<Tab> buildLocalTabs() {
    var local = AppLocal.of(context);
    List<Tab> lTabs = tabMonths.map((tm) {
      String tabStr = local.getHumanTrxPeriod(tm);
      return Tab(
        key: Key(tabStr),
        text: tabStr,
      );
    }).toList();
    return lTabs;
  }

  String getGroupPeriod() {
    var local = AppLocal.of(context);
    return "${local.getHumanTrxPeriod(group.sdt)} - ${local.getHumanTrxPeriod(group.edt)}";
  }

  @override
  Widget build(BuildContext context) {
    String title = "${group.name} ";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              getGroupPeriod(),
            ),
          ),
        ],
        bottom: TabBar(
          tabs: buildLocalTabs(),
          isScrollable: true,
          controller: tabController,
        ),
      ),
      body: MemberDetailsList(
        key: Key("md_${selectedTrxPeriodDt.toIso8601String()}"),
        trxPeriodDt: selectedTrxPeriodDt,
        group: group,
        viewMode: "table",
      ),
    );
  }
}
