import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../service/theme/theme.dart';
import '../../state_machine/event_bus/theme_events.dart';
import '../../state_machine/get_it/app_get_it.dart';
import '../common/buttons/transparent_text_button.dart';

class MobileDarkModeButton extends StatefulWidget {

  const MobileDarkModeButton({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileDarkModeButton> createState() => _MobileDarkModeButtonState();
}

class _MobileDarkModeButtonState extends State<MobileDarkModeButton> {
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
          return TransTextButton(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(isDarkMode ? "夜间" : "白天",),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(isDarkMode ? Icons.nightlight_rounded : Icons.wb_sunny,),
                )
              ],
            ),
            onPressed: () {
              isDarkMode = !isDarkMode;
              ThemeSwitcher.of(context).changeTheme(
                theme: isDarkMode
                    ? ThemeUtil.getDarkTheme()
                    : ThemeUtil.getPreSetTheme(themeName),
              );
            },
          );
        }
    );
  }
}
