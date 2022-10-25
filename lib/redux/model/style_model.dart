import 'package:responsive_builder/responsive_builder.dart';

class StyleModel{
  final DeviceScreenType deviceScreenType;

  StyleModel({
    required this.deviceScreenType
  });

  double factor = 1.0;

  /// 返回当前运行的设备屏幕类型
  DeviceScreenType getDeviceScreenType() {
    return deviceScreenType;
  }


}

class styleData {
  static Map<DeviceScreenType, double> drawerFactor = {
    DeviceScreenType.mobile : 0.9,
    DeviceScreenType.tablet : 0.5,
    DeviceScreenType.desktop : 0.4,
  };
}