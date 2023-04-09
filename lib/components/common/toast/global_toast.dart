import 'dart:async';
import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/toast/toast_widget.dart';

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

  static void show(String message, {
    Duration duration = const Duration(seconds: 2),
    ToastType type = ToastType.normal,
    ToastPosition position = ToastPosition.center,
  })
  {
    assert(() {
      if (_overlayState == null) {
        throw FlutterError('showToast() must be called after init()');
      }
      return true;
    }());

    hideToast();

    _toastOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => ToastWidget(message: message, type: type, position: position,),
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

  static void showErrorTop(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.error, position: ToastPosition.top,);
  }
  static void showErrorCenter(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.error, position: ToastPosition.center,);
  }
  static void showErrorBottom(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.error, position: ToastPosition.bottom,);
  }

  static void showSuccessTop(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.success, position: ToastPosition.top,);
  }
  static void showSuccessCenter(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.success, position: ToastPosition.center,);
  }
  static void showSuccessBottom(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.success, position: ToastPosition.bottom,);
  }

  static void showWarningTop(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.warning, position: ToastPosition.top,);
  }
  static void showWarningCenter(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.warning, position: ToastPosition.center,);
  }
  static void showWarningBottom(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.warning, position: ToastPosition.bottom,);
  }

  static void showNormalTop(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.normal, position: ToastPosition.top,);
  }
  static void showNormalCenter(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.normal, position: ToastPosition.center,);
  }
  static void showNormalBottom(String message, {Duration duration = const Duration(seconds: 2),}) {
    show(message, duration: duration, type: ToastType.normal, position: ToastPosition.bottom,);
  }
}
