import 'package:flutter/material.dart';

enum ToastType {
  error,
  normal,
  warning,
  success,
}

enum ToastPosition {
  top,
  center,
  bottom,
}

class ToastWidget extends StatelessWidget {
  final String message;
  final ToastType type;
  final ToastPosition position;

  const ToastWidget({
    Key? key,
    required this.message,
    this.type = ToastType.normal,
    this.position = ToastPosition.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position == ToastPosition.top ? 100.0 : null,
      bottom: position == ToastPosition.bottom ? 100.0 : null,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.symmetric(horizontal: 20.0),
        // padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
        child: Card(
          color: _getColor(type),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getIcon(type),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Colors.green;
      case ToastType.warning:
        return Colors.amber;
      case ToastType.error:
        return Colors.red;
      case ToastType.normal:
      default:
        return Colors.black87;
    }
  }

  static Icon _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Icon(Icons.check_circle, color: Colors.white);
      case ToastType.warning:
        return const Icon(Icons.warning, color: Colors.white);
      case ToastType.error:
        return const Icon(Icons.error, color: Colors.white);
      case ToastType.normal:
      default:
        return const Icon(Icons.info, color: Colors.white);
    }
  }
}
