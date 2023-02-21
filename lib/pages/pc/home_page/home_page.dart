import 'package:flutter/material.dart';
import '../../../components/common/float_button.dart';
import '../../../components/common/left_drawer/left_drawer.dart';
import '../../../components/common/right_drawer/right_drawer.dart';
import '../../common/chapter_edit_page/chapter_edit_page.dart';
import '../../common/setting_edit_page/setting_edit_page.dart';

class PCHomePage extends StatefulWidget {
  const PCHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCHomePage> createState() => _PCHomePageState();
}

class _PCHomePageState extends State<PCHomePage> {

  /// 详情框打开状态
  bool isDetailOpened = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const ChapterEditPageAppBar(),
        drawerEdgeDragWidth: screenSize.width / 2.0,
        drawer: const LeftDrawer(widthFactor: 0.3,),
        endDrawer: const RightDrawer(widthFactor: 0.3,),
        body: Row(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height / (isDetailOpened ? 36.0 : 12.0),
                    horizontal: screenSize.width / (isDetailOpened ? 15.0 : 5.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    ChapterEditPageBody(),
                  ],
                ),
              ),
            ),
            isDetailOpened
                ? const Expanded(flex: 1, child: SettingEditPage())
                : const SizedBox()
          ],
        ),
        floatingActionButton: FloatButton(
          callback: () {
            setState(() {
              isDetailOpened = !isDetailOpened;
            });
          },
        )
    );
  }
}
