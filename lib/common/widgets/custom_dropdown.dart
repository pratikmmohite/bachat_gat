/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/material.dart';

typedef CustomOptionChangeFunc<T> = void Function(
    CustomDropDownOption<T> option);

class CustomDropDown<T> extends StatefulWidget {
  final String label;
  final String? value;
  final List<CustomDropDownOption<T>> options;
  final CustomOptionChangeFunc<T>? onChange;
  const CustomDropDown({
    super.key,
    required this.label,
    this.value,
    this.options = const [],
    this.onChange,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  CustomDropDownOption<T>? selectedOptionObject;
  Future<CustomDropDownOption<T>?> showOptions() async {
    List<Widget> optionsList = widget.options
        .map((e) => ListTile(
              leading: widget.value == e.value
                  ? const Icon(Icons.check_circle)
                  : null,
              onTap: () {
                Navigator.of(context).pop(e);
              },
              title: Text(e.label),
            ))
        .toList();
    return showDialog<CustomDropDownOption<T>?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.label),
          content: SingleChildScrollView(
            child: ListBody(
              children: optionsList,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    var x = widget.options.where((op) => op.value == widget.value);
    selectedOptionObject = x.isNotEmpty ? x.first : null;
    super.initState();
  }

  Widget buildMenuDropDown() {
    var dropOptions = widget.options
        .map(
          (e) => DropdownMenuEntry<CustomDropDownOption<T>>(
            value: e,
            label: e.label,
            leadingIcon:
                widget.value == e.value ? const Icon(Icons.check_circle) : null,
          ),
        )
        .toList();

    return Container(
      margin: const EdgeInsets.all(2),
      child: DropdownMenu<CustomDropDownOption<T>>(
        label: Text(widget.label),
        initialSelection: selectedOptionObject,
        expandedInsets: EdgeInsets.zero,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        ),
        dropdownMenuEntries: dropOptions,
        onSelected: (option) {
          try {
            if (option != null && widget.onChange != null) {
              setState(() {
                selectedOptionObject = option;
              });
              widget.onChange!(option);
            }
          } catch (e) {
            // print(e);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMenuDropDown();
  }
}

class CustomDropDownOption<T> {
  String label;
  String value;
  T valueObj;
  CustomDropDownOption(this.label, this.value, this.valueObj);
}
