import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
class PcCustomWindowButton extends StatefulWidget {

  const PcCustomWindowButton({
    Key? key,
  }) : super(key: key);

  @override
  State<PcCustomWindowButton> createState() => _PcCustomWindowButtonState();
}

class _PcCustomWindowButtonState extends State<PcCustomWindowButton> {

  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    Color themeColor = Theme.of(context).primaryColor;
    return Row(
      children: [
        MinimizeWindowButton(colors: WindowButtonTheme.getButtonColors(themeColor)),
        appWindow.isMaximized
            ? RestoreWindowButton(
          colors: WindowButtonTheme.getButtonColors(themeColor),
          onPressed: maximizeOrRestore,
        )
            : MaximizeWindowButton(
          colors: WindowButtonTheme.getButtonColors(themeColor),
          onPressed: maximizeOrRestore,
        ),
        CloseWindowButton(colors: WindowButtonTheme.getCloseButtonColors(themeColor),),
      ],
    );
  }
}

class WindowButtonTheme {
  static Color? themeColor;
  static late HSLColor hslColor;
  static late double lightness;
  static late double saturation;

  static late WindowButtonColors buttonColors;
  static late WindowButtonColors closeButtonColors;

  static void init(Color inputColor) {
    themeColor = inputColor;
    hslColor = HSLColor.fromColor(themeColor!);
    lightness = hslColor.lightness;
    saturation = hslColor.saturation;
    buttonColors = WindowButtonColors(
      iconNormal: Color.alphaBlend(
        const Color(0xFF805306).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      mouseOver: Color.alphaBlend(
        const Color(0xFFF6A00C).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      mouseDown: Color.alphaBlend(
        const Color(0xFF805306).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      iconMouseOver: Color.alphaBlend(
        const Color(0xFF805306).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      iconMouseDown: Color.alphaBlend(
        const Color(0xFFFFD500).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
    );
    closeButtonColors = WindowButtonColors(
      mouseOver: Color.alphaBlend(
        const Color(0xFFD32F2F).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      mouseDown: Color.alphaBlend(
        const Color(0xFFB71C1C).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      iconNormal: Color.alphaBlend(
        const Color(0xFF805306).withOpacity(0.8),
        HSLColor.fromAHSL(1.0, lightness, saturation, 1.0).toColor(),
      ),
      iconMouseOver: Colors.white,
    );
  }

  static WindowButtonColors getButtonColors(Color inputColor) {
    if (themeColor != null && themeColor == inputColor) {
      return buttonColors;
    }
    init(inputColor);
    return buttonColors;
  }

  static WindowButtonColors getCloseButtonColors(Color inputColor) {
    if (themeColor != null && themeColor == inputColor) {
      return closeButtonColors;
    }
    init(inputColor);
    return closeButtonColors;
  }
}
