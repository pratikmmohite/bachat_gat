/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/common/common_index.dart';
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

import '../../models/models_index.dart';
import '../pdf/pdf_api.dart';

class MemberReport extends StatefulWidget {
  const MemberReport(this.group, this.members, this.intitalName, {super.key});
  final Group group;
  final List<GroupMember> members;
  final String intitalName;

  @override
  State<MemberReport> createState() => _MemberReportState();
}

class _MemberReportState extends State<MemberReport> {
  late Group _group;
  late List<GroupMember> _members;
  late String selectedMemberId;
  late List<MemberTransactionDetails> memberData;
  late String selectedMemberName;
  late DateTime _startDate;
  DateTime _endDate = DateTime.now();
  DateTimeRange dtchnage =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  String formatDt(DateTime dt) {
    return dt.toString().split(" ")[0];
  }

  late TextEditingController _textController = TextEditingController(
      text: "${formatDt(_startDate)} to ${formatDt(_endDate)}");

  Widget getButtons() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () async {
            try {
              var bytes = await PdfApi.generatePdf(
                  memberId: selectedMemberId,
                  groupId: _group.id,
                  startDate: _startDate,
                  endDate: _endDate,
                  memberName: selectedMemberName,
                  groupName: _group.name,
                  context: context);
              await PdfApi.saveAsPDF(bytes, selectedMemberName);
            } catch (e) {
              AppUtils.toast(context, "Failed to generate Pdf");
            }
          },
          label: const Text('Download'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.download),
          onPressed: () async {
            try {
              var bytes = await PdfApi.generatePdf(
                  memberId: selectedMemberId,
                  groupId: _group.id,
                  startDate: _startDate,
                  endDate: _endDate,
                  memberName: selectedMemberName,
                  groupName: _group.name,
                  context: context);

              await PdfApi.previewPDF(bytes, selectedMemberName);
            } catch (e) {
              AppUtils.toast(context, "Failed to generate Pdf");
            }
          },
          label: const Text('Preview'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.share),
          onPressed: () async {
            try {
              var bytes = await PdfApi.generatePdf(
                  memberId: selectedMemberId,
                  groupId: _group.id,
                  startDate: _startDate,
                  endDate: _endDate,
                  memberName: selectedMemberName,
                  groupName: _group.name,
                  context: context);
              await PdfApi.sharePDF(bytes, selectedMemberName + ".pdf");
            } catch (e) {
              AppUtils.toast(context, "Failed to generate Pdf");
            }
          },
          label: const Text('Share'),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _members = widget.members;
    selectedMemberId = _members.isEmpty ? "" : _members[0].id;
    selectedMemberName = _members.isEmpty ? " " : _members[0].name;
    _startDate = DateTime(_endDate.year, _endDate.month - 1, 1);

    _textController = TextEditingController(
        text: "${formatDt(_startDate)} to ${formatDt(_endDate)}");
  }

  @override
  Widget build(BuildContext context) {
    var local = AppLocal.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.lmReport),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown for Member List
            CustomDropDown<GroupMember>(
              value: selectedMemberId,
              onChange: (newValue) {
                setState(() {
                  selectedMemberId = newValue.value;
                  selectedMemberName = _members
                      .firstWhere((member) => member.id == newValue.value)
                      .name;
                });
              },
              options: _members.map((valueItem) {
                return CustomDropDownOption(
                    valueItem.name, valueItem.id, valueItem);
              }).toList(),
              label: 'Select Member',
            ),
            const SizedBox(height: 15),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Date ",
                hintText: "Enter ${local.tfStartDate}",
                filled: true,
              ),
              controller: _textController,
              onTap: () async {
                var dt = DateTimeRange(start: _startDate, end: _endDate);
                DateTimeRange? selectedRange = await showDateRangePicker(
                  context: context,
                  initialDateRange: dt,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2099),
                );
                if (selectedRange != null) {
                  setState(() {
                    _startDate = selectedRange.start;
                    _endDate = selectedRange.end;
                    _textController.text =
                        "${formatDt(selectedRange.start)} to ${formatDt(selectedRange.end)}";
                    dtchnage = selectedRange;
                  });
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            getButtons()
          ],
        ),
      ),
    );
  }
}
