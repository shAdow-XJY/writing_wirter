import 'package:animated_stack/animated_stack.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      fabBackgroundColor: Theme.of(context).highlightColor,
      columnWidget: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.output,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.cloud,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.desktop_windows,),
            onPressed: () {},
          ),
        ],
      ),
      bottomWidget: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings,),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
