import 'dart:async';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/pc/sockets_page/pc_sockets_page.dart';
import '../../service/theme/theme.dart';
import '../../state_machine/event_bus/theme_events.dart';
import '../../state_machine/get_it/app_get_it.dart';

class PCFloatButton extends StatefulWidget {
  const PCFloatButton({
    Key? key,
  }) : super(key: key);
  @override
  State<PCFloatButton> createState() => _PCFloatButtonState();
}

class _PCFloatButtonState extends State<PCFloatButton> {
  /// 全局单例-缓存读取工具类
  final SharedPreferences sharedPreferences = appGetIt.get(instanceName: "SharedPreferences");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;

  /// 夜间模式开启
  late String themeName;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    if (sharedPreferences.getString("themeName") != null) {
      themeName = sharedPreferences.getString("themeName")!;
    } else {
      themeName = ThemeUtil.getThemeName(null);
    }
    if (sharedPreferences.getBool("isDarkMode") == true) {
      isDarkMode = true;
    } else {
      isDarkMode = false;
    }
    subscription_1 = eventBus.on<ChangeThemeEvent>().listen((event) {
      setState(() {
        isDarkMode = sharedPreferences.getBool("isDarkMode")!;
        themeName = sharedPreferences.getString("themeName")!;
      });
    });
  }
  
  @override
  void dispose() {
    sharedPreferences.setBool("isDarkMode", isDarkMode);
    subscription_1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (BuildContext context) {
        return CircularMenu(
          alignment: Alignment.bottomRight,
          toggleButtonColor: Colors.pink,
          items: [
            CircularMenuItem(
              icon: Icons.settings,
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/setting');
              },
            ),
            CircularMenuItem(
              icon: Icons.output,
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/export');
              },
            ),
            CircularMenuItem(
              icon: Icons.cloud,
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/cloud');
              },
            ),
            CircularMenuItem(
              icon: Icons.phone_android,
              color: Colors.purple,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const PCSocketsPage(),
                );
              },
            ),
            CircularMenuItem(
              icon: isDarkMode ? Icons.nightlight_rounded : Icons.wb_sunny,
              color: Colors.brown,
              onTap: () {
                isDarkMode = !isDarkMode;
                ThemeSwitcher.of(context).changeTheme(
                  theme: isDarkMode
                      ? ThemeUtil.getDarkTheme()
                      : ThemeUtil.getPreSetTheme(themeName),
                );
              },
            )
          ],
        );
      },
    );
  }
}
