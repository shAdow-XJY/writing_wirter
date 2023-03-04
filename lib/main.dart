import 'package:flutter/material.dart';
import 'package:writing_writer/state_machine/get_it/app_get_it.dart';

/// pc 端
import 'entry/pc/pc_main.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupAppGetIt();
  runApp(PcApp());
}

// /// mobile 端
// import 'entry/mobile/mobile_main.dart';
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   setupAppGetIt();
//   runApp(MobileApp());
// }
