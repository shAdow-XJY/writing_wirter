import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';

class PCFloatButton extends StatefulWidget {
  const PCFloatButton({
    Key? key,
  }) : super(key: key);
  @override
  State<PCFloatButton> createState() => _PCFloatButtonState();
}

class _PCFloatButtonState extends State<PCFloatButton> {
  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomRight,
      toggleButtonColor: Colors.pink,
      items: [
        CircularMenuItem(
          icon: Icons.settings,
          color: Colors.orange,
          onTap: () {},
        ),
        CircularMenuItem(
          icon: Icons.output,
          color: Colors.green,
          onTap: () {},
        ),
        CircularMenuItem(
          icon: Icons.cloud,
          color: Colors.blue,
          onTap: () {},
        ),
        CircularMenuItem(
          icon: Icons.phone_android,
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, '/sockets');
          },
        ),
        CircularMenuItem(
          icon: Icons.remove_red_eye,
          color: Colors.brown,
          onTap: () {},
        )
      ],
    );
  }
}
