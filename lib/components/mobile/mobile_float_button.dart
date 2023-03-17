import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';

import '../../pages/mobile/sockets_page/mobile_sockets_page.dart';
import '../common/buttons/transparent_text_button.dart';

class MobileFloatButton extends StatefulWidget {
  final Widget mainPage;
  const MobileFloatButton({
    Key? key,
    required this.mainPage,
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
      fabBackgroundColor: Theme.of(context).highlightColor,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      columnWidget: Column(
        children: [
          TransTextButton(
            child: Row(
              children: const [
                Expanded(
                  flex: 1,
                  child: Text("通知"),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.notifications,),
                )
              ],
            ),
            onPressed: () {},
          ),
          TransTextButton(
            child: Row(
              children: const [
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
            onPressed: () {},
          ),
        ],
      ),
      bottomWidget: Row(
        children: [
          TransTextButton(
            child: Column(
              children: const [
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
            child: Column(
              children: const [
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
            onPressed: () {},
          ),
          TransTextButton(
            child: Column(
              children: const [
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
    );
  }
}
