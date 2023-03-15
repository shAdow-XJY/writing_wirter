import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drop_down_button.dart';

class SelectToastDialog extends StatefulWidget {
  final String title;
  final Function(String) callBack;
  final List<String> items;
  final String? hintText;
  final int? initIndex;
  const SelectToastDialog({
    Key? key,
    required this.title,
    required this.callBack,
    required this.items,
    this.hintText,
    this.initIndex,
  }) : super(key: key);

  @override
  State<SelectToastDialog> createState() => _SelectToastDialogState();
}

class _SelectToastDialogState extends State<SelectToastDialog> {

  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    print(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      body: CupertinoAlertDialog(
        title: Text(widget.title,),
        content: DropDownButton(
          initIndex: widget.initIndex,
          hintText: widget.hintText,
          items: widget.items,
          onChanged: (String selected) {
            selectedValue = selected;
          },
        ),
        actions: <Widget>[
          CupertinoButton(
            child: const Text("取消"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoButton(
            child: const Text("确定"),
            onPressed: () {
              widget.callBack(selectedValue);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}