import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextToastDialog extends StatefulWidget {
  final String title;
  final String text;
  final VoidCallback callBack;
  const TextToastDialog({
    Key? key,
    required this.title,
    required this.text,
    required this.callBack,
  }) : super(key: key);

  @override
  State<TextToastDialog> createState() => _TextToastDialogState();
}

class _TextToastDialogState extends State<TextToastDialog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      body: CupertinoAlertDialog(
        title: Text(widget.title,),
        content: Text(widget.text),
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
              widget.callBack();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}