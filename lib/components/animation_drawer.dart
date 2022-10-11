import 'package:flutter/material.dart';

class AnimationDrawer extends StatefulWidget {
  const AnimationDrawer({Key? key,}) : super(key: key);

  @override
  State<AnimationDrawer> createState() => _AnimationDrawerState();
}

class _AnimationDrawerState extends State<AnimationDrawer> with TickerProviderStateMixin{

  late AnimationController controller;
  late Animation<Offset> animation;

  void animInit(){
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this,);
    animation = Tween(begin: const Offset(0.9, 0), end: Offset.zero).animate(controller);
  }

  @override
  void initState() {
    super.initState();
    animInit();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.0,
        child: Text('asd'),
      )
    );
  }

}