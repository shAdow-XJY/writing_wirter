import 'package:flutter/material.dart';
import '../../../components/common/left_drawer/left_drawer.dart';
import '../../../components/common/right_drawer/right_drawer.dart';
import '../../../components/common/buttons/semicircle_button.dart';
import '../../../components/common/transparent_bar_scroll_view.dart';
import '../../../components/pc/pc_float_button.dart';
import '../../common/chapter_edit_page/chapter_edit_app_bar.dart';
import '../chapter_edit_page/pc_chapter_edit_body.dart';
import '../setting_edit_page/pc_setting_edit_page.dart';

class PCHomePage extends StatefulWidget {
  const PCHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCHomePage> createState() => _PCHomePageState();
}

class _PCHomePageState extends State<PCHomePage>{

  /// 侧边按钮
  bool openSettingPage = false;

  ///
  bool _isDragging = false;

  final double _drawerFactor = 0.2;

  final double _minLeftFactor = 0.5;
  final double _maxLeftFactor = 0.666;
  final double _buttonFactor = 0.033;
  /// 分割线位置
  double _dividerPosition = 0.633;

  double _minLeftWidth = 0;
  double _maxLeftWidth = 0;
  double _totalWidth = 0;
  double _drawerWidth = 0;

  double leftWidth = 0.0;
  double rightWidth = 0.0;
  double buttonWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _dividerPosition = openSettingPage ? 0.633 : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    _drawerWidth = MediaQuery.of(context).size.width * _drawerFactor;
    _totalWidth = MediaQuery.of(context).size.width - _drawerWidth * 2;
    buttonWidth = _totalWidth * _buttonFactor;
    if (openSettingPage) {
      _minLeftWidth = _totalWidth * _minLeftFactor;
      _maxLeftWidth = _totalWidth * _maxLeftFactor;
      leftWidth = (_totalWidth * (_dividerPosition - _buttonFactor)).clamp(_minLeftWidth, _maxLeftWidth);
      rightWidth = _totalWidth - leftWidth -buttonWidth;
    } else {
      leftWidth = _totalWidth * (_dividerPosition - _buttonFactor);
    }

    return Scaffold(
        appBar: const ChapterEditPageAppBar(),
        // drawer: const LeftDrawer(widthFactor: 0.2,),
        // endDrawer: const RightDrawer(widthFactor: 0.2,),
        body: Stack(
          children: [
            Row(
              children: [
                LeftDrawer(widthFactor: _drawerFactor,),
                SizedBox(
                  width: leftWidth,
                  height: double.infinity,
                  child: const TransBarScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PCChapterEditPageBody(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: buttonWidth,
                  child: SemicircleButton(
                    icon: openSettingPage ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    callback: () {
                      setState(() {
                        openSettingPage = !openSettingPage;
                        _dividerPosition = 1.0;
                      });
                    },
                  ),
                ),
                openSettingPage
                    ? SizedBox(width: rightWidth, child: const PCSettingEditPage(),)
                    : const SizedBox.shrink(),
                RightDrawer(widthFactor: _drawerFactor,),
              ],
            ),
            Positioned(
              left: _drawerWidth + leftWidth + buttonWidth - 2,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeLeftRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    if (openSettingPage) {
                      setState(() {
                        _isDragging = true;
                      });
                    }
                  },
                  onPanUpdate: (details) {
                    if (_isDragging) {
                      setState(() {
                        _dividerPosition += details.delta.dx * 2.5 / _totalWidth;
                        _dividerPosition = _dividerPosition.clamp(0.0, 1.0);
                      });
                    }
                  },
                  onPanEnd: (_) {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: Container(
                    width: 4,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: const PCFloatButton()
    );
  }
}
