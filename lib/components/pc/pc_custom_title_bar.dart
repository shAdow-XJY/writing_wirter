import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/components/pc/pc_custom_window_button.dart';

const toolBarHeight = 40.0;

class PcCustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const PcCustomTitleBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(toolBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: toolBarHeight,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: CircleAvatar(
            child: ClipOval(
              child: Image.asset('assets/icon/app.png'),
            )
        ),
      ),
      centerTitle: true,
      title: const Text(
        'Writing Writer',
        style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400
        ),
      ),
      elevation: 1.0,
      flexibleSpace: MoveWindow(),
      actions: const [PcCustomWindowButton()],
    );
  }
}