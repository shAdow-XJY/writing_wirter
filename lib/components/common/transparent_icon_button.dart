import 'package:flutter/material.dart';

class TransIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const TransIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: icon,
      onPressed: () {
        onPressed();
      },
    );
  }
}