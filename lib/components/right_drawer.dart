import 'package:flutter/material.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({Key? key,}) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 3.0,
    );
  }

}