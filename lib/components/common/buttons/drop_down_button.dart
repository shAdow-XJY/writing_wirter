import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropDownButton extends StatefulWidget {
  final List<String> items;
  final Function(String) onChanged;
  final String? hintText;
  final int? initIndex;
  final double buttonWidth;

  const DropDownButton({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.initIndex,
    this.buttonWidth = 140,
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
    if (initIndex != null && initIndex! >= 0) {
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
    if (widget.initIndex != null &&
        (initIndex != widget.initIndex || !widget.items.contains(selectedValue))) {
      initIndex = widget.initIndex!;
      selectedValue = widget.items.elementAtOrNull(initIndex!);
    } else if (selectedValue != null && !widget.items.contains(selectedValue)) {
      selectedValue = widget.items.elementAtOrNull(0);
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonHeight: 40,
        buttonWidth: widget.buttonWidth,
        itemHeight: 40,
        focusColor: Colors.transparent,
        selectedItemHighlightColor: Theme.of(context).primaryColorDark,
        dropdownDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColorDark],
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        buttonDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColorDark],
          ),
        ),
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
