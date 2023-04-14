import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/toast/global_toast.dart';

class NumberEditDialog extends StatefulWidget {
  final String title;
  final Function(String) callBack;
  final String init;
  const NumberEditDialog({
    Key? key,
    required this.title,
    required this.callBack,
    this.init = '',
  }) : super(key: key);

  @override
  State<NumberEditDialog> createState() => _NumberEditDialogState();
}

class _NumberEditDialogState extends State<NumberEditDialog> {

  /// 输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.init;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.transparent.withOpacity(0.5),
      title: Text(widget.title,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '请输入大于0的正整数~',
            ),
          )
        ],
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
            if (textEditingController.text.isEmpty) {
              GlobalToast.showErrorTop('请输入数字');
              return;
            } else if (int.tryParse(textEditingController.text) == null) {
              GlobalToast.showErrorTop('请输入有效数字');
              return;
            } else if (int.parse(textEditingController.text) < 1) {
              GlobalToast.showErrorTop('请输入大于等于1的数字');
              return;
            }
            widget.callBack(textEditingController.text);
          },
        ),
      ],
    );
  }
}