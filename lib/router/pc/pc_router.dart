import 'package:flutter/material.dart';
import 'package:writing_writer/pages/pc/space_edit_page/space_edit_page.dart';

import '../../pages/common/pre_page/pre_page.dart';
import '../../pages/pc/home_page/home_page.dart';
import '../../pages/pc/sockets_page/sockets_page.dart';

/// 需要引入跳转页面地址

/// 配置路由
final routes = {
  /// 前面是自己的命名 后面是加载的方法
  /// 不用传参的写法
  '/': (context) => const PCSocketsPage(),
  '/home': (context) => const PCSocketsPage(),
  '/sockets': (context) => const PCSocketsPage(),
  '/space': (context) => const SpaceEditPage(),
};

/// 固定写法，统一处理，无需更改
var pcGenerateRoute = (RouteSettings settings) {
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
