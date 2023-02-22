import 'package:flutter/material.dart';

class SemicircleButton extends StatefulWidget {
  final VoidCallback callback;
  const SemicircleButton(
      {
        Key? key,
        required this.callback,
      }) : super(key: key);

  @override
  State<SemicircleButton> createState() => _SemicircleButtonState();
}

class _SemicircleButtonState extends State<SemicircleButton>{
  bool clickAgain = true;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(45.0), right: Radius.circular(0.0)),
        ),
        onPressed: () {
          setState(() {
            clickAgain = !clickAgain;
          });
          widget.callback();
        },
        color: Theme.of(context).focusColor,
        height: 60.0,
        minWidth: 15.0,
        child: SizedBox(
          height: 10.0,
          width: 10.0,
          child: Icon(
            clickAgain ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
            size: 10.0,
          ),
        )
    );
  }

}