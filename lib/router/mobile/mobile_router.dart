import 'package:flutter/material.dart';

import '../../pages/common/cloud_page/cloud_page.dart';
import '../../pages/common/pre_page/pre_page.dart';
import '../../pages/common/setting_page/setting_page.dart';
import '../../pages/mobile/export_page/mobile_export_page.dart';
import '../../pages/mobile/home_page/mobile_home_page.dart';
/// 需要引入跳转页面地址

/// 配置路由
final routes = {
  /// 前面是自己的命名 后面是加载的方法
  /// 不用传参的写法
  '/': (context) => const PrePage(),
  '/home': (context) => const MobileHomePage(),
  '/export': (context) => const MobileExportPage(),
  '/cloud': (context) => const CloudPage(),
  '/setting': (context) => const SettingPage(),
};

/// 固定写法，统一处理，无需更改
var mobileGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  if (name != null) {
    final Function? pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    }
  }
};
