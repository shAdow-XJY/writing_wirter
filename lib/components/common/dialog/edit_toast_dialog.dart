import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditToastDialog extends StatefulWidget {
  final String title;
  final Function(String) callBack;
  final String init;
  const EditToastDialog({
    Key? key,
    required this.title,
    required this.callBack,
    this.init = '',
  }) : super(key: key);

  @override
  State<EditToastDialog> createState() => _EditToastDialogState();
}

class _EditToastDialogState extends State<EditToastDialog> {

  /// 输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.init;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.transparent.withOpacity(0.5),
      title: Text(widget.title,),
      content: TextField(
        controller: textEditingController,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("确定"),
          onPressed: () {
            widget.callBack(textEditingController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}