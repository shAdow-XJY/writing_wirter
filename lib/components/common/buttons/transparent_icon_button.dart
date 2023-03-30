import 'package:flutter/material.dart';

class TransIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;

  const TransIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      focusColor: Colors.transparent,
      hoverColor: Theme.of(context).focusColor,
      splashRadius: 20.0,
      splashColor: Theme.of(context).focusColor.withOpacity(0.2),
      highlightColor: Colors.transparent,
      icon: icon,
      onPressed: () {
        onPressed();
      },
    );
  }
}