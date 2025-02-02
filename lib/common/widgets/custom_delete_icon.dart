/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:bachat_gat/locals/app_local_delegate.dart';
import 'package:flutter/material.dart';

typedef CustomDeleteIconChangeFunc<T> = void Function(T option);

class CustomDeleteIcon<T> extends StatefulWidget {
  final T item;
  final Widget? content;
  final CustomDeleteIconChangeFunc<T>? onAccept;
  final CustomDeleteIconChangeFunc<T>? onCancel;
  const CustomDeleteIcon(
      {super.key,
      required this.onAccept,
      this.onCancel,
      required this.item,
      this.content});

  @override
  State<CustomDeleteIcon<T>> createState() => _CustomDeleteIconState<T>();
}

class _CustomDeleteIconState<T> extends State<CustomDeleteIcon<T>> {
  Future<void> showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var local = AppLocal.of(context);
        return AlertDialog(
          title: Text(local.mConfirmDeleteMsg),
          content: widget.content,
          actions: <Widget>[
            TextButton(
              child: Text(local.bNo),
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!(widget.item);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(local.bYes),
              onPressed: () {
                try {
                  if (widget.onAccept != null) {
                    widget.onAccept!(widget.item);
                  }

                } catch (e) {
                  // print(e);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDeleteDialog();
      },
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
    );
  }
}
