import 'package:flutter/material.dart';

import '../../pages/mobile/sockets_page/mobile_sockets_page.dart';
import '../common/buttons/transparent_text_button.dart';
import 'mobile_dark_mode_button.dart';

class MobileFloatButton extends StatefulWidget {
  final Widget mainPage;
  final Function(bool) onOpen;
  const MobileFloatButton({
    Key? key,
    required this.mainPage,
    required this.onOpen,
  }) : super(key: key);
  @override
  State<MobileFloatButton> createState() => _MobileFloatButtonState();
}

class _MobileFloatButtonState extends State<MobileFloatButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedStack(
      foregroundWidget: widget.mainPage,
      scaleHeight: 80.0,
      scaleWidth: 65.0,
      fabBackgroundColor: Theme.of(context).primaryColorLight,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      columnWidget: Column(
        children: [
          const MobileDarkModeButton(),
          TransTextButton(
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("设置"),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.settings,),
                )
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
        ],
      ),
      bottomWidget: Row(
        children: [
          TransTextButton(
            child: const Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("分享"),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.share,),
                )
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/export');
            },
          ),
          TransTextButton(
            child: const Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("云端"),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.cloud,),
                )
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cloud');
            },
          ),
          TransTextButton(
            child: const Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("同步"),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.desktop_windows,),
                )
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const MobileSocketsPage(),
              );
            },
          ),
        ],
      ),
      onChanged: (bool opened) {
        widget.onOpen(opened);
      },
    );
  }
}
