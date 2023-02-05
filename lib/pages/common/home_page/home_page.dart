import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/state_machine/get_it/app_get_it.dart';
import '../../../components/common/float_button.dart';
import '../../../components/common/left_drawer/left_drawer.dart';
import '../../../components/common/right_drawer/right_drawer.dart';
import '../../../components/common/toast_dialog.dart';
import '../../../server/file/IOBase.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../detail_sub_page/detail_sub_page.dart';
import '../edit_sub_page/edit_sub_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt<IOBase>();

  /// text
  String currentBook = "";
  String currentChapter = "";

  /// 详情框打开状态
  bool isDetailOpened = true;

  /// 章节重命名
  void changeChapterName(String newChapterName) {
    if (newChapterName.compareTo(currentChapter) == 0) {
      return;
    }
    // 重命名文件
    ioBase.renameChapter(currentBook, currentChapter, newChapterName);
    currentChapter = newChapterName;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint('store in home_page');
        currentBook = store.state.textModel.currentBook;
        currentChapter = store.state.textModel.currentChapter;
        void renameChapter() {
          store.dispatch(SetTextDataAction(currentBook: currentBook, currentChapter: currentChapter));
        }
        return {
          "currentBook": currentBook,
          "currentChapter": currentChapter,
          "renameChapter": renameChapter,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: InkWell(
              child: Text(map["currentChapter"] ?? ""),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ToastDialog(
                    title: '章节重命名',
                    init: currentChapter,
                    callBack: (strBack) => {
                      if (strBack.isNotEmpty)
                        {
                          changeChapterName(strBack),
                          map["renameChapter"](),
                        },
                    },
                  ),
                );
              },
            ),
            actions: [
              Builder(builder: (BuildContext context) {
                return IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              })
            ],
          ),
          drawerEdgeDragWidth: screenSize.width / 2.0,
          drawer: const LeftDrawer(),
          endDrawer: const RightDrawer(),
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
                        EditSubPage(),
                      ],
                    ),
                  ),
              ),
              isDetailOpened
                  ? const Expanded(flex: 1, child: DetailSubPage())
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
      },
    );
  }
}
