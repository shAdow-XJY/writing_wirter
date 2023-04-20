import 'package:flutter/material.dart';
import '../buttons/drop_down_button.dart';

class RenameDialogMap {
  final bool isChooseOne;
  final String selectedString;
  final String inputString;
  RenameDialogMap({
    required this.isChooseOne,
    required this.selectedString,
    required this.inputString,
  });
}

class RenameOrDialog extends StatefulWidget {
  final String dialogTitle;
  final String titleOne;
  final String titleTwo;
  final String initInputText;
  final List<String>? items;
  final Function(RenameDialogMap) callBack;

  const RenameOrDialog({
    Key? key,
    required this.dialogTitle,
    required this.titleOne,
    required this.titleTwo,
    this.initInputText = '',
    this.items,
    required this.callBack,
  }) : super(key: key);

  @override
  State<RenameOrDialog> createState() => _RenameOrDialogState();
}

class _RenameOrDialogState extends State<RenameOrDialog> {
  int _selectedIndex = 0;

  final TextEditingController textEditingController = TextEditingController();

  /// 回调数据
  String selectedString = '';
  String inputString = '';

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.initInputText;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            selected: _selectedIndex == 0,
            leading: const Icon(Icons.edit_outlined),
            title: Text(widget.titleOne),
          ),
          ListTile(
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            selected: _selectedIndex == 1,
            leading: const Icon(Icons.edit_rounded),
            title: Text(widget.titleTwo),
          ),
          if (_selectedIndex == 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: DropDownButton(
                items: widget.items??[],
                buttonWidth: double.infinity,
                hintText: '选择要重命名的一项',
                onChanged: (String selected) {
                  selectedString = selected;
                  textEditingController.text = selected;
                },
              ),
            ),
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: '输入新名称'),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            // if (_selectedIndex == 1 && selectedString.isEmpty) {
            //   GlobalToast.showWarningTop('选项列表中没有选中');
            //   return;
            // } else if (textEditingController.text.isEmpty) {
            //   GlobalToast.showWarningTop('输入框中没有内容');
            //   return;
            // }

            inputString = textEditingController.text;
            widget.callBack(
                RenameDialogMap(
                    isChooseOne: _selectedIndex == 0,
                    selectedString: selectedString,
                    inputString: inputString,
                ),
            );
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
