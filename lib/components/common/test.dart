import 'package:flutter/material.dart';

class HorizontalLayout extends StatefulWidget {
  const HorizontalLayout({Key? key}) : super(key: key);

  @override
  _HorizontalLayoutState createState() => _HorizontalLayoutState();
}

class _HorizontalLayoutState extends State<HorizontalLayout> {
  bool _isDragging = false;
  double _dividerPosition = 0.3;
  double _minLeftWidth = 100;
  double _maxLeftWidth = 300;
  double _totalWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _totalWidth = context.size!.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _totalWidth = constraints.maxWidth;
        final leftWidth = _totalWidth * _dividerPosition;
        final rightWidth = _totalWidth - leftWidth;
        return Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: leftWidth.clamp(_minLeftWidth, _maxLeftWidth),
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text("Left Content"),
                ),
              ),
            ),
            Positioned(
              left: leftWidth,
              top: 0,
              bottom: 0,
              width: rightWidth,
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text("Right Content"),
                ),
              ),
            ),
            Positioned(
              left: leftWidth - 2,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _dividerPosition += details.delta.dx / _totalWidth;
                      _dividerPosition = _dividerPosition.clamp(0, 1);
                    });
                  },
                  onPanEnd: (_) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: Container(
                    width: 4,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
