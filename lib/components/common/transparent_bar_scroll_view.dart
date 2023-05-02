import 'dart:ui';
import 'package:flutter/material.dart';

class TransBarScrollView extends StatelessWidget {
  final Widget child;
  const TransBarScrollView({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            dragDevices: {
              PointerDeviceKind.touch,
            },
        ),
        child: SingleChildScrollView(
          child: child,
        ),
    );
  }
}