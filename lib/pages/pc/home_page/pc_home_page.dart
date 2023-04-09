import 'package:flutter/material.dart';
import '../../../components/common/dialog/global_toast.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const ChapterEditPageAppBar(),
        drawer: const LeftDrawer(widthFactor: 0.3,),
        endDrawer: const RightDrawer(widthFactor: 0.3,),
        body: Row(
          children: [
            const Expanded(
              flex: 20,
              child: TransBarScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    PCChapterEditPageBody(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SemicircleButton(
                icon: openSettingPage ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                callback: () {
                  setState(() {
                    GlobalToast.show('This is a toast!');
                    openSettingPage = !openSettingPage;
                  });
                },
              ),
            ),
            RotatedBox(
              quarterTurns: 1,
              child: Divider(
                height: 2,
                thickness: 2,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            openSettingPage
                ? const Expanded(flex: 9, child: PCSettingEditPage(),)
                : const SizedBox(height: double.infinity,)
          ],
        ),
        floatingActionButton: const PCFloatButton()
    );
  }
}
