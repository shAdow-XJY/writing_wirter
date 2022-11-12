import 'package:flutter/material.dart';

class TransCheckBox extends StatelessWidget {
  final bool initBool;
  final Function(bool) onChanged;

  const TransCheckBox({
    Key? key,
    this.initBool = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      activeColor: Theme.of(context).colorScheme.inversePrimary,
      checkColor: Theme.of(context).colorScheme.background,
      value: initBool,
      onChanged: (bool? value) {
        onChanged(value!);
      },
    );
  }
}