import 'package:flutter/material.dart';
import '../../../components/common/left_drawer/left_drawer.dart';
import '../../../components/common/right_drawer/right_drawer.dart';
import '../../common/chapter_edit_page/chapter_edit_page.dart';
import '../../common/setting_edit_page/setting_edit_page.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {

  /// 页面切换初始化
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _bodyPages = [const ChapterEditPageBody(), const SettingEditPage(),];

  /// 抽屉手势开关
  bool enableLeft = true;
  bool enableRight = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const ChapterEditPageAppBar(),
        drawerEdgeDragWidth: screenSize.width / 2.0,
        drawer: const LeftDrawer(widthFactor: 0.9,),
        endDrawer: const RightDrawer(widthFactor: 0.9,),
        drawerEnableOpenDragGesture: enableLeft,
        endDrawerEnableOpenDragGesture: enableRight,
        body: PageView.builder(
            onPageChanged: (int index){
              setState(() {
                if (index == 0) {
                  enableLeft = true;
                  enableRight = false;
                } else {
                  enableLeft = false;
                  enableRight = true;
                }
              });
            },
            controller: _pageController,
            itemCount: _bodyPages.length,
            itemBuilder: (BuildContext context, int index){
              return _bodyPages.elementAt(index);
            }
        ),
    );
  }
}
