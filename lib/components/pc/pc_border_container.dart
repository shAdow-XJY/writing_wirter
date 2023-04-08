import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';


class PcBorderContainer extends StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String title;
  final Widget child;

  const PcBorderContainer({
    Key? key,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(16.0),
    this.title = '',
    required this.child,
  }) : super(key: key);
  
  @override
  State<PcBorderContainer> createState() => _PcBorderContainerState();
}

class _PcBorderContainerState extends State<PcBorderContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: DottedBorder(
        strokeWidth: 5.0,
        padding: widget.padding,
        borderPadding: widget.margin,
        dashPattern: _isHovered ? [1, 0] : [25, 5],
        color: _isHovered ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title.isNotEmpty)
              Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _isHovered ? Theme.of(context).primaryColorDark : Colors.grey,
                    ),
                    top: BorderSide.none,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: _isHovered ? Theme.of(context).primaryColorDark : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            widget.child,
          ],
        ),
      ),
    );
  }
}
