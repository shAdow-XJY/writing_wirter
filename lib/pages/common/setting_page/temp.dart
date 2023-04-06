import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final String title;

  const CustomContainer({
    Key? key,
    this.width = double.infinity,
    this.height = 100.0,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(16.0),
    this.title = '',
  }) : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isHovered ? Theme.of(context).primaryColorDark : Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title.isNotEmpty)
              Text(
                widget.title,
                style: TextStyle(
                  color: _isHovered ? Theme.of(context).primaryColorDark : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
