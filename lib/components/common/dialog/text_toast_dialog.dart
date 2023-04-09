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
    return AlertDialog(
      title: Text(widget.title,),
      content: Text(widget.text),
      shadowColor: Colors.transparent.withOpacity(0.5),
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
            widget.callBack();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}