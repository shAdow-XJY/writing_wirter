import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/transparent_bar_scroll_view.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("设置页面"),
      ),
      body: TransBarScrollView(
          child: Column(
            children: const [
              Text("WevDAV 账号"),
              Text("WevDAV 密码"),
            ],
          )
      ),
    );
  }
}
