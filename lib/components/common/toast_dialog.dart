import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastDialog extends StatefulWidget {
  final String title;
  final Function(String) callBack;
  final String init;
  const ToastDialog({
    Key? key,
    required this.title,
    required this.callBack,
    this.init = '',
  }) : super(key: key);

  @override
  State<ToastDialog> createState() => _ToastDialogState();
}

class _ToastDialogState extends State<ToastDialog> {

  /// 输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.init;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoAlertDialog(
        title: Text(widget.title,),
        content: TextField(
          controller: textEditingController,
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
              widget.callBack(textEditingController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}