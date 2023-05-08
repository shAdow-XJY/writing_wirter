import 'package:flutter/material.dart';

class ThemeUtil {
  /// 搭配sharedPreferences缓存中的key
  /// themeName: red/pink/blueGrey
  /// isDarkMode: true/false
  /// 缓存中的变量如果为空，即之前没有赋过值，初始化为下面的变量
  /// themeName = "blueGrey"
  /// isDarkMode = false

  /// 默认主题
  static String defaultTheme = "blueGrey";
  static ColorSwatch defaultColor = Colors.blueGrey;

  /// 预设主题色调
  static Map<String, ColorSwatch> colorsMap = {
    "red": Colors.red,
    "pink": Colors.pink,
    "amber": Colors.amber,
    "yellow": Colors.yellow,
    "blueGrey": Colors.blueGrey,
    "lightGreen": Colors.lightGreen,
    "deepPurple": Colors.deepPurple,
  };

  /// 预设主题色调: key
  static String getThemeName(ColorSwatch? selectedColor) {
    String key = defaultTheme;
    if (selectedColor != null) {
      for (var color in colorsMap.entries) {
        if (color.value.value.compareTo(selectedColor.value) == 0) {
          key = color.key;
          break;
        }
      }
    }
    return key;
  }

  /// 预设主题色调: value
  static Color? getColor(String? themeName) {
    if (colorsMap.containsKey(themeName)) {
      return colorsMap[themeName];
    }
    return defaultColor;
  }

  /// 预设主题色调: values 数组
  static List<ColorSwatch> getColorsList() {
    return colorsMap.values.toList();
  }

  /// 获取初始主题
  static ThemeData getInitTheme({String? themeName, bool? isDarkMode}) {
    debugPrint(themeName);
    debugPrint(isDarkMode.toString());
    if (isDarkMode == true) {
      return getDarkTheme();
    }
    return getPreSetTheme(themeName);
  }

  /// 获取预设主题色调主题
  static ThemeData getPreSetTheme(String? themeName) {
    if (colorsMap.containsKey(themeName)) {
      return generateTheme(colorsMap[themeName]!);
    }
    return generateTheme(defaultColor);
  }

  /// 获取预设夜间模式主题
  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.blueGrey,
      ),
    );
  }

  /// ColorSwatch 转化为 MaterialColor
  static MaterialColor convertToMaterialColor(ColorSwatch primaryColor) {
    Color color = Color(primaryColor.value);
    return  MaterialColor(
      primaryColor.value,
      <int, Color>{
        50: primaryColor[50] ?? color,
        100: primaryColor[100] ?? color,
        200: primaryColor[200] ?? color,
        300: primaryColor[300] ?? color,
        400: primaryColor[400] ?? color,
        500: primaryColor[500] ?? color,
        600: primaryColor[600] ?? color,
        700: primaryColor[700] ?? color,
        800: primaryColor[800] ?? color,
        900: primaryColor[900] ?? color,
      },
    );
  }

  /// ThemeData 生成函数
  static ThemeData generateTheme(ColorSwatch color) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: convertToMaterialColor(color),
      primaryColor: color[600],
      dialogBackgroundColor: color[100],
      scaffoldBackgroundColor: color[100],
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: color[600],
      ),
      appBarTheme: AppBarTheme(
        color: color[600],
        toolbarTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all(color[600]),
          overlayColor: MaterialStateProperty.all(color[700]),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 2,
          ),
        ),
      ),
    );
  }
}