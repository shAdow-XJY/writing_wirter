import 'package:flutter/material.dart';
import 'package:writing_writer/state_machine/get_it/app_get_it.dart';

// /// pc 端
// import 'entry/pc/pc_main.dart';
// import 'package:bitsdojo_window/bitsdojo_window.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setupAppGetIt();
//   runApp(PcApp());
//
//   doWhenWindowReady(() {
//     final win = appWindow;
//     const initialSize = Size(1080, 700);
//     win.minSize = initialSize;
//     win.size = initialSize;
//     win.alignment = Alignment.center;
//     win.title = "Writing Writer";
//     win.show();
//   });
// }

// /// mobile 端
// import 'entry/mobile/mobile_main.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await setupAppGetIt();
//   runApp(MobileApp());
// }

/// mobile 端 在desktop端 运行，debug 方便用
import 'entry/mobile/mobile_main.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupAppGetIt();
  runApp(MobileApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(400, 750);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.centerLeft;
    win.title = "Writing Writer";
    win.show();
  });
}
