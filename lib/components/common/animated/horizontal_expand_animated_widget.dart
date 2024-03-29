import 'package:flutter/material.dart';

class HorizontalExpandAnimatedWidget extends StatefulWidget {
  final bool isExpanded;
  final Widget child;

  const HorizontalExpandAnimatedWidget({
    Key? key,
    required this.isExpanded,
    required this.child
  }) : super(key: key);

  @override
  State<HorizontalExpandAnimatedWidget> createState() => _HorizontalExpandAnimatedWidgetState();
}

class _HorizontalExpandAnimatedWidgetState extends State<HorizontalExpandAnimatedWidget> with SingleTickerProviderStateMixin {

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HorizontalExpandAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } else if (widget.isExpanded) {
      _controller.forward(from: 0.0);
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
