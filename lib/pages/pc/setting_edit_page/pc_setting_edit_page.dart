import 'package:flutter/material.dart';
import 'package:writing_writer/pages/common/setting_edit_page/common_setting_edit_page.dart';

class PCSettingEditPage extends StatefulWidget {
  const PCSettingEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCSettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<PCSettingEditPage> {

  /// 设定内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonSettingEditPage(textEditingController: textEditingController);
  }
}