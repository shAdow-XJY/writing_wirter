import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  final List<String> items;
  final Function(String) onChanged;
  final String? hintText;
  final int? initIndex;

  const DropDownButton({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.initIndex,
  }) : super(key: key);

  @override
  State<DropDownButton> createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  String? selectedValue;
  int? initIndex;

  @override
  void initState() {
    super.initState();
    initIndex = widget.initIndex;
    if (initIndex! >= 0) {
      selectedValue = widget.items[initIndex as int];
    }
  }

  @override
  void dispose() {
    selectedValue = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initIndex != widget.initIndex || !widget.items.contains(selectedValue!)) {
      initIndex = widget.initIndex;
      selectedValue = widget.items[initIndex as int];
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonHeight: 40,
        buttonWidth: 140,
        itemHeight: 40,
        focusColor: Colors.transparent,
        hint: Text(
          widget.hintText??'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        dropdownMaxHeight: 400,
        value: selectedValue,
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
            widget.onChanged(selectedValue??"");
          });
        },
      ),
    );
  }
}
