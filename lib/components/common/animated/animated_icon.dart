import 'package:flutter/material.dart';

class AnimatedArrow extends StatefulWidget {
  @override
  _AnimatedArrowState createState() => _AnimatedArrowState();
}

class _AnimatedArrowState extends State<AnimatedArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // 创建一个动画控制器
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..repeat(reverse: true); // 循环播放动画，reverse: true 表示反向播放
  }

  @override
  void dispose() {
    // 释放资源
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedIcon(
      // 指定图标类型，这里使用箭头向右的图标
      icon: AnimatedIcons.search_ellipsis,
      // 指定动画控制器
      progress: _animationController,
    );
  }
}