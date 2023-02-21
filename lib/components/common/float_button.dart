import 'package:flutter/material.dart';

class FloatButton extends StatefulWidget {
  final VoidCallback callback;
  const FloatButton(
      {
        Key? key,
        required this.callback,
      }) : super(key: key);

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton>{
  bool clickAgain = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: '详情框',
      onPressed: () {
        clickAgain = !clickAgain;
        widget.callback();
      },
      child: Icon(clickAgain ? Icons.check : Icons.close),
    );
  }

}