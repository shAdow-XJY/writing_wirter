import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:writing_writer/components/common/transparent_bar_scroll_view.dart';
import 'package:writing_writer/pages/common/setting_page/temp.dart';
import 'package:writing_writer/service/theme/theme.dart';
import '../../../components/pc/pc_border_container.dart';
import '../../../service/file/config_IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  /// 全局单例-用户配置操作工具类
  final ConfigIOBase configIOBase = appGetIt.get(instanceName: "ConfigIOBase");

  /// 用户配置属性
  late Map<String, dynamic> userJson;

  /// webDAV
  TextEditingController uriController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Theme
  Color? selectedColor;

  @override
  void initState() {
    super.initState();
    userJson = configIOBase.getUserJsonContent();
    uriController.text = userJson["webDAV"]["uri"];
    userController.text = userJson["webDAV"]["user"];
    passwordController.text = userJson["webDAV"]["password"];
  }

  @override
  void dispose() {
    saveAll();
    super.dispose();
  }

  /// 保存设置页面所有配置
  void saveAll() {
    userJson["webDAV"]["uri"] = uriController.text;
    userJson["webDAV"]["user"] = userController.text;
    userJson["webDAV"]["password"] = passwordController.text;
    configIOBase.saveUserJson(userJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("设置页面"),
      ),
      body: TransBarScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PcBorderContainer(
              title: "WebDAV 云端账户",
              child: Column(
                children: [
                  TextFormField(
                    controller: uriController,
                    decoration: const InputDecoration(
                      labelText: "WebDAV 链接",
                      hintText: "WebDAV 网盘链接",
                      icon: Icon(Icons.cloud_circle),
                    ),
                  ),
                  TextFormField(
                    controller: userController,
                    decoration: const InputDecoration(
                      labelText: "WebDAV 账号",
                      hintText: "WebDAV 账号",
                      icon: Icon(Icons.person),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: "WebDAV 密码",
                      hintText: "WebDAV 密码",
                      icon: Icon(Icons.password_rounded),
                    ),
                  ),
                ],
              ),
            ),
            PcBorderContainer(
              title: "主题外观",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ThemeSwitcher(
                    builder: (BuildContext context) {
                      return MaterialColorPicker(
                        onMainColorChange: (color) {
                          selectedColor = Color(color!.value);
                          ThemeSwitcher.of(context).changeTheme(
                            theme: ThemeUtil.generateTheme(color),
                          );
                        },
                        selectedColor: selectedColor,
                        colors: ThemeUtil.colors,
                        allowShades: false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



