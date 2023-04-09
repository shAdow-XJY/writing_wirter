import 'dart:async';
import 'package:flutter/material.dart';

class GlobalToast {
  static final GlobalToast _singleton = GlobalToast._internal();

  factory GlobalToast() {
    return _singleton;
  }

  GlobalToast._internal();

  static OverlayState? _overlayState;
  static late OverlayEntry _toastOverlayEntry;

  static bool _isVisible = false;

  static late Timer _timer;

  static Future<void> init(BuildContext context) async {
    _overlayState ??= Overlay.of(context);
  }

  static void show(String message, {Duration duration = const Duration(seconds: 2)}) {
    assert(() {
      if (_overlayState == null) {
        throw FlutterError('showToast() must be called after init()');
      }
      return true;
    }());

    hideToast();

    _toastOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Text(
                message,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
      ),
    );

    _overlayState!.insert(_toastOverlayEntry);
    _isVisible = true;

    _timer = Timer(duration, () {
      _toastOverlayEntry.remove();
      _isVisible = false;
    });
  }

  static void hideToast() {
    if (_isVisible) {
      _timer.cancel();
      _toastOverlayEntry.remove();
      _isVisible = false;
    }
  }
}
