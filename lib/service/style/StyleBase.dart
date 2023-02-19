import 'package:responsive_builder/responsive_builder.dart';

class StyleBase {
  static double defaultDrawerWidthFactor = 0.4;
  /// 抽屉宽度因子
  static Map<DeviceScreenType, double> drawerWidthFactor = {
    DeviceScreenType.mobile : 0.9,
    DeviceScreenType.tablet : 0.4,
    DeviceScreenType.desktop : 0.4,
  };
  /// 返回抽屉的宽度因子
  static double getDrawerWidthFactor(DeviceScreenType deviceScreenType) {
    return drawerWidthFactor[deviceScreenType] ?? defaultDrawerWidthFactor;
  }

}