import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme.dart';

class MySharedPreferences {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    /// init 变量， 之后 get 不用进行 null check
    if (prefs.getBool("isDarkMode") == null) {
      await prefs.setBool("isDarkMode", false);
    }
    if (prefs.getString("themeName") == null) {
      await prefs.setString("themeName", ThemeUtil.getThemeName(null));
    }
  }
}
