import 'package:flutter/material.dart';
import '../../../components/common/left_drawer/left_drawer.dart';
import '../../../components/common/right_drawer/right_drawer.dart';
import '../../../components/common/slide_transition_x.dart';
import '../../../components/common/transparent_bar_scroll_view.dart';
import '../../../components/mobile/mobile_float_button.dart';
import '../../common/chapter_edit_page/chapter_edit_app_bar.dart';
import '../chapter_edit_page/mobile_chapter_edit_body.dart';
import '../setting_edit_page/mobile_setting_edit_page.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> with SingleTickerProviderStateMixin {
  /// 页面切换初始化
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _widgetList = [
    const SizedBox(
      key: ValueKey("MobileChapterEditPageBody"),
      height: double.infinity,
      child: TransBarScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MobileChapterEditPageBody(),
          ],
        ),
      ),
    ),
    const MobileSettingEditPage(
      key: ValueKey("MobileSettingEditPage"),
    ),
  ];

  late int _currentIndex;
  late Widget _currentWidget;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _currentWidget = _widgetList[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return MobileFloatButton(
      mainPage: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0.0) > 0.0) {
            // 手势向左滑动
            if (scaffoldKey.currentState!.isEndDrawerOpen) {
              scaffoldKey.currentState!.closeEndDrawer();
            } else if (_currentIndex == 1) {
              setState(() {
                _currentIndex = 0;
                _currentWidget = _widgetList[_currentIndex];
              });
            } else if (!scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.openDrawer();
            }
          } else if ((details.primaryVelocity ?? 0.0) < 0.0) {
            // 手势向右滑动
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else if (_currentIndex == 0) {
              setState(() {
                _currentIndex = 1;
                _currentWidget = _widgetList[_currentIndex];
              });
            } else if (!scaffoldKey.currentState!.isEndDrawerOpen) {
              scaffoldKey.currentState!.openEndDrawer();
            }
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          extendBody: true,
          appBar: const ChapterEditPageAppBar(),
          drawer: const LeftDrawer(widthFactor: 0.9),
          endDrawer: const RightDrawer(widthFactor: 0.9),
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            switchInCurve: Curves.decelerate,
            switchOutCurve: _currentIndex == 0 ? Curves.decelerate : Curves.bounceIn,
            child: _currentWidget,
            transitionBuilder: (child, animation) {
              return SlideTransitionX(
                direction: _currentIndex == 0 ? AxisDirection.right : AxisDirection.left,
                position: animation,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
