import 'package:flutter/material.dart';

class TransTextButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const TransTextButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(Theme.of(context).iconTheme.color),
        overlayColor: MaterialStateProperty.all(Theme.of(context).focusColor),
      ),
      onPressed: () {
        onPressed();
      },
      child: child,
    );
  }
}