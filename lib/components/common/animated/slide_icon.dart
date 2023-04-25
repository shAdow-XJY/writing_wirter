import 'package:flutter/cupertino.dart';

class SlideIcon extends StatefulWidget {
  final Icon icon;
  const SlideIcon(
      {
        super.key,
        required this.icon,
      });

  @override
  State<SlideIcon> createState() => _SlideIconState();
}

class _SlideIconState extends State<SlideIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.5, 0.0),
      ).animate(_controller),
      child: widget.icon,
    );
  }
}