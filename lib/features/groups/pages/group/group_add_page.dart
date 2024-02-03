import 'package:bachat_gat/common/common_index.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/widgets_index.dart';
import '../../dao/groups_dao.dart';
import '../../models/models_index.dart';

class GroupAddPage extends StatefulWidget {
  final Group? group;
  const GroupAddPage({super.key, this.group});

  @override
  State<GroupAddPage> createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Group group;
  late GroupsDao dao;
  bool isAdd = true;

  @override
  void initState() {
    super.initState();
    if (widget.group == null) {
      isAdd = true;
      group = Group.withDefault();
    } else {
      isAdd = false;
      group = widget.group!;
    }
    dao = GroupsDao();
  }

  void closePage() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Saving Group")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                    label: "Group Name",
                    field: "name",
                    isRequired: true,
                    value: group.name,
                    onChange: (value) {
                      group.name = value;
                    }),
                CustomDateField(
                  label: "Start Date",
                  field: "sdt_edt",
                  value: group.sdt,
                  onChange: (value) {
                    setState(() {
                      group.sdt = value;
                      group.edt =
                          DateTime(value.year + 1, value.month, value.day);
                    });
                  },
                ),
                CustomTextField(
                  key: Key("edt_dt_${group.edt.toString()}"),
                  label: "End Date",
                  field: "end_dt",
                  value: group.edt.toString().split(" ")[0],
                  onChange: (value) {},
                  readOnly: true,
                  keyboardType: TextInputType.none,
                ),
                CustomTextField(
                  label: "Address",
                  field: "address",
                  value: group.address ?? "",
                  onChange: (value) {
                    group.address = value;
                  },
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        CustomTextField(
                          label: "Bank Name",
                          field: "bankName",
                          value: group.bankName ?? "",
                          onChange: (value) {
                            group.bankName = value;
                          },
                        ),
                        CustomTextField(
                          label: "Account No",
                          field: "accountNo",
                          value: group.accountNo ?? "",
                          onChange: (value) {
                            group.accountNo = value;
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        CustomTextField(
                          label: "IFSC Code",
                          field: "ifscCode",
                          value: group.ifscCode ?? "",
                          onChange: (value) {
                            group.ifscCode = value;
                          },
                        ),
                        CustomDateField(
                          label: "Account Opening Date",
                          field: "accountOpeningDate",
                          value: group.accountOpeningDate,
                          onChange: (value) {
                            setState(() {
                              group.accountOpeningDate = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                const Text("Group Settings"),
                Table(
                  children: [
                    TableRow(
                      children: [
                        CustomTextField(
                          label: "Installment Amount",
                          field: "installmentAmt",
                          suffixIcon: const Icon(Icons.currency_rupee),
                          value:
                              "${(group.installmentAmtPerMonth ?? 0).toInt()}",
                          onChange: (value) {
                            group.installmentAmtPerMonth =
                                double.tryParse(value) ?? 0;
                          },
                        ),
                        CustomTextField(
                          label: "Loan Interest",
                          field: "loanInterestPer",
                          suffixIcon: const Icon(Icons.percent),
                          value:
                              "${(group.loanInterestPercentPerMonth ?? 0).toInt()}",
                          onChange: (value) {
                            group.loanInterestPercentPerMonth =
                                double.tryParse(value) ?? 0;
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        CustomTextField(
                          label: "Late Fee",
                          field: "lateFeePerDay",
                          suffixIcon: const Icon(Icons.currency_rupee),
                          value: "${(group.lateFeePerDay ?? 0).toInt()}",
                          onChange: (value) {
                            group.lateFeePerDay = double.tryParse(value) ?? 0;
                          },
                        ),
                        CustomSpace(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            int updatedRows = 0;
            if (isAdd) {
              updatedRows = await dao.addGroup(group);
            } else {
              updatedRows = await dao.updateGroup(group);
            }
            if (updatedRows > 0) {
              closePage();
            }
          }
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}