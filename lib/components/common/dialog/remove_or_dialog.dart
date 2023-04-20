import 'package:flutter/material.dart';
import '../buttons/drop_down_button.dart';

class RemoveDialogMap {
  final bool isChooseOne;
  final String selectedOne;
  final String selectedTwo;
  RemoveDialogMap({
    required this.isChooseOne,
    required this.selectedOne,
    required this.selectedTwo,
  });
}

class RemoveOrDialog extends StatefulWidget {
  final String dialogTitle;
  final String titleOne;
  final String titleTwo;
  final String hintTextOne;
  final String hintTextTwo;
  final List<String>? itemsOne;
  final List<String>? itemsTwo;
  final List<String> Function(String)? getItemsTwo;
  final Function(RemoveDialogMap) callBack;

  const RemoveOrDialog({
    Key? key,
    required this.dialogTitle,
    required this.titleOne,
    required this.titleTwo,
    this.hintTextOne = '',
    this.hintTextTwo = '',
    this.itemsOne,
    this.itemsTwo,
    this.getItemsTwo,
    required this.callBack,
  }) : super(key: key);

  @override
  State<RemoveOrDialog> createState() => _RemoveOrDialogState();
}

class _RemoveOrDialogState extends State<RemoveOrDialog> {
  int _selectedIndex = 0;

  /// 回调数据
  String selectedOne = '';
  String selectedTwo = '';

  List<String> getItemsTwoInner(String selectedOne) {
    if (widget.getItemsTwo == null) {
      return widget.itemsTwo??[];
    }
    return widget.getItemsTwo!(selectedOne);
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: DropDownButton(
              items: widget.itemsOne??[],
              buttonWidth: double.infinity,
              hintText: widget.hintTextOne,
              onChanged: (String selected) {
                setState(() {
                  selectedOne = selected;
                });
              },
            ),
          ),
          if (_selectedIndex == 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: DropDownButton(
                items: getItemsTwoInner(selectedOne),
                buttonWidth: double.infinity,
                hintText: widget.hintTextTwo,
                onChanged: (String selected) {
                  selectedTwo = selected;
                },
              ),
            ),
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
            widget.callBack(
                RemoveDialogMap(
                  isChooseOne: _selectedIndex == 0,
                  selectedOne: selectedOne,
                  selectedTwo: selectedTwo,
                ),
            );
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
