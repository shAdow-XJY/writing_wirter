import 'package:responsive_builder/responsive_builder.dart';

class StyleModel{
  DeviceScreenType deviceScreenType;

  StyleModel({
    required this.deviceScreenType
  });

  final double _defaultFactor = 1.0;

  /// 返回当前运行的设备屏幕类型
  DeviceScreenType getDeviceScreenType() {
    return deviceScreenType;
  }

  /// 判断设备屏幕类型
  bool isDesktop() {
    return deviceScreenType == DeviceScreenType.desktop;
  }
  bool isTablet() {
    return deviceScreenType == DeviceScreenType.tablet;
  }
  bool isMobile() {
    return deviceScreenType == DeviceScreenType.mobile;
  }

  /// 返回抽屉的宽度因子
  double getDrawerWidthFactor() {
    return StyleData.drawerWidthFactor[deviceScreenType] ?? _defaultFactor;
  }
}

class StyleData {
  static Map<DeviceScreenType, double> drawerWidthFactor = {
    DeviceScreenType.mobile : 0.9,
    DeviceScreenType.tablet : 0.5,
    DeviceScreenType.desktop : 0.4,
  };
}