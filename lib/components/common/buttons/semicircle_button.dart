import 'package:flutter/material.dart';

class SemicircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback callback;
  const SemicircleButton(
      {
        Key? key,
        required this.icon,
        required this.callback,
      }) : super(key: key);

  @override
  State<SemicircleButton> createState() => _SemicircleButtonState();
}

class _SemicircleButtonState extends State<SemicircleButton>{

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(45.0), right: Radius.circular(0.0)),
        ),
        onPressed: () {
          widget.callback();
        },
        color: Theme.of(context).primaryColorDark,
        height: 60.0,
        minWidth: 15.0,
        child: SizedBox(
          height: 10.0,
          width: 10.0,
          child: Icon(
            widget.icon,
            size: 10.0,
          ),
        )
    );
  }

}