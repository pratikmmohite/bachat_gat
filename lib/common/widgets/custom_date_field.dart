/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/material.dart';

class CustomDateField extends StatelessWidget {
  final String label;
  final String field;
  final DateTime value;
  final bool futureDataDisable;
  final ValueChanged<DateTime> onChange;

  const CustomDateField({
    super.key,
    required this.label,
    required this.field,
    required this.value,
    required this.onChange,
    this.futureDataDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: value.toString().split(" ")[0],
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
        ),
        readOnly: true,
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: futureDataDisable ? DateTime.now() : DateTime(2099),
          );
          if (selectedDate != null) {
            onChange(selectedDate);
          }
        },
      ),
    );
  }
}
