import 'package:responsive_builder/responsive_builder.dart';

class StyleModel{
  DeviceScreenType deviceScreenType;

  StyleModel({
    required this.deviceScreenType
  });

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

}