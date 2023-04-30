import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/state_machine/get_it/app_get_it.dart';

/// pc 端
import 'entry/pc/pc_main.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupAppGetIt();
  runApp(PcApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(980, 650);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

// /// mobile 端
// import 'entry/mobile/mobile_main.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setupAppGetIt();
//   runApp(MobileApp());
// }
