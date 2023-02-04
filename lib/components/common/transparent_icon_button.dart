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
      hoverColor: Theme.of(context).focusColor,
      splashRadius: 20.0,
      splashColor: Theme.of(context).focusColor.withOpacity(0.1),
      highlightColor: Colors.transparent,
      icon: icon,
      onPressed: () {
        onPressed();
      },
    );
  }
}