import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:writing_writer/router/pc/pc_router.dart';
import 'package:writing_writer/service/theme/theme.dart';
import '../../state_machine/get_it/app_get_it.dart';
import '../../state_machine/redux/app_state/state.dart';

class PcApp extends StatelessWidget {
  PcApp({Key? key,}) : super(key: key);

  final store = Store<AppState>(appReducer, initialState: AppState.initialState());

  /// 全局单例-缓存读取工具类
  final SharedPreferences prefs = appGetIt.get(instanceName: "SharedPreferences");

  @override
  Widget build(BuildContext context) {
    /// 使用StoreProvider 包裹根元素，使其提供store
    return StoreProvider(
      store: store,
      /// 为了能直接在child使用store，我们这里要继续包裹一层StoreBuilder
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return ThemeProvider(
            initTheme: ThemeUtil.getInitTheme(themeName: prefs.getString("themeName"), isDarkMode: prefs.getBool("isDarkMode")),
            builder: (context, myTheme) {
              return MaterialApp(
                  title: 'Writing Writer',
                  theme: myTheme,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        flexibleSpace: MoveWindow(),
                        actions: [
                          WindowButtons()
                        ],
                      ),
                      body: child,
                    );
                  },
                  initialRoute: '/',
                  onGenerateRoute: pcGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  _WindowButtonsState createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
          colors: buttonColors,
          onPressed: maximizeOrRestore,
        )
            : MaximizeWindowButton(
          colors: buttonColors,
          onPressed: maximizeOrRestore,
        ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
