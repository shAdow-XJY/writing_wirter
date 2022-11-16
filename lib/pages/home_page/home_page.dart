import 'package:blur_glass/blur_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../components/float_button.dart';
import '../../components/left_drawer/left_drawer.dart';
import '../../components/right_drawer/right_drawer.dart';
import '../../components/toast_dialog.dart';
import '../../redux/action/text_action.dart';
import '../../redux/app_state/state.dart';
import '../../server/file/IOBase.dart';
import '../detail_sub_page/detail_sub_page.dart';
import '../readmode_sub_page/readmode_sub_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// 文件操作类
  IOBase ioBase = IOBase();

  /// 章节内容输入框控制器
  late final TextEditingController textEditingController;

  /// text
  String currentBook = "";
  String currentChapter = "";

  /// 输入框的内容
  String currentText = "";

  /// 详情框打开状态
  bool isDetailOpened = false;

  /// 获取文本
  String getText() {
    if (currentBook.isEmpty || currentChapter.isEmpty) {
      return '';
    }
    return ioBase.getChapterContent(currentBook, currentChapter);
  }

  /// 保存/更新文本
  void saveText() {
    if (currentBook.isEmpty || currentChapter.isEmpty) {
      return;
    }
    ioBase.saveChapter(currentBook, currentChapter, currentText);
  }

  /// 章节重命名
  void changeChapterName(String newChapterName) {
    if (newChapterName.compareTo(currentChapter) == 0) {
      return;
    }
    // 先保存再重命名文件
    ioBase.saveChapter(currentBook, currentChapter, currentText);
    ioBase.renameChapter(currentBook, currentChapter, newChapterName);
    currentChapter = newChapterName;
  }

  @override
  void initState() {
    super.initState();
    ///控制 初始化的时候光标保持在文字最后
    textEditingController = TextEditingController.fromValue(
      ///用来设置初始化时显示
      TextEditingValue(
        ///用来设置文本 controller.text = "0000"
        text: currentText,
        ///设置光标的位置
        selection: TextSelection.fromPosition(
          ///用来设置文本的位置
          TextPosition(
              affinity: TextAffinity.downstream,
              /// 光标向后移动的长度
              offset: currentText.length),
        ),
      ),
    );

    /// 添加兼听 当TextFeild 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextFeild文本发生改变时才会回调
    textEditingController.addListener(() {
      ///获取输入的内容
      currentText = textEditingController.text;
      debugPrint(" controller 兼听章节内容 $currentText");
    });
  }

  @override
  void dispose() {
    saveText();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        saveText();
        currentBook = store.state.textModel.currentBook;
        currentChapter = store.state.textModel.currentChapter;
        textEditingController.text = getText();
        currentText = textEditingController.text;
        void renameChapter() {
          store.dispatch(SetTextDataAction(currentBook: currentBook, currentChapter: currentChapter));
        }
        return {
          "currentBook": currentBook,
          "currentChapter": currentChapter,
          "currentText": currentText,
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
                      children: <Widget>[
                        /// 毛玻璃组件做写字板背景
                        BlurGlass(
                          child: TextField(
                            controller: textEditingController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              /// 消除下边框
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const ReadModeSubPage()
                      ],
                    ),
                  ),
              ),
              isDetailOpened
                  ? Expanded(flex: 1, child: DetailSubPage(ioBase: ioBase,))
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
