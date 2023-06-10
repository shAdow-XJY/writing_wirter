import 'package:flutter/material.dart';

class VerticalExpandAnimatedWidget extends StatefulWidget {
  final bool isExpanded;
  final Widget child;

  const VerticalExpandAnimatedWidget({
    Key? key, 
    required this.isExpanded,
    required this.child
  }) : super(key: key);

  @override
  State<VerticalExpandAnimatedWidget> createState() => _VerticalExpandAnimatedWidgetState();
}

class _VerticalExpandAnimatedWidgetState extends State<VerticalExpandAnimatedWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 添加以下代码以确保初始状态正确
    if (widget.isExpanded) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VerticalExpandAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      curve: Curves.easeInOut,
      child: SizeTransition(
        sizeFactor: _animation,
        child: widget.child,
      ),
    );
  }
}
