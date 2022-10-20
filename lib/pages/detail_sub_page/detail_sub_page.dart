import 'package:blur_glass/blur_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../components/toast_dialog.dart';
import '../../redux/action/set_action.dart';
import '../../redux/app_state/state.dart';
import '../../server/file/IOBase.dart';

class DetailSubPage extends StatefulWidget {
  final IOBase ioBase;
  const DetailSubPage(
      {
        Key? key,
        required this.ioBase,
      }) : super(key: key);

  @override
  State<DetailSubPage> createState() => _DetailSubPageState();
}

class _DetailSubPageState extends State<DetailSubPage>{
  /// 主页面传过来的ioBase类
  late final IOBase ioBase;
  /// 章节内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  /// status
  String currentBook = "";
  String currentSet = "";
  String currentSetting = "";

  /// 输入框的内容
  String currentText = "";

  /// 详情框打开状态
  bool isDetailOpened = false;

  /// 获取文本
  String getText() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return '';
    }
    return ioBase.getSettingContent(currentBook, currentSet, currentSetting);
  }

  /// 保存/更新文本
  void saveText() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return;
    }
    ioBase.saveSetting(currentBook, currentSet, currentSetting, currentText);
  }

  /// 章节重命名
  void changeSettingName(String newSettingName) {
    if (newSettingName.compareTo(currentSetting) == 0) {
      return;
    }
    // 先保存再重命名文件
    ioBase.saveSetting(currentBook, currentSet, currentSetting, currentText);
    ioBase.renameSetting(currentBook, currentSet, currentSetting, newSettingName);
    currentSetting = newSettingName;
  }

  @override
  void initState() {
    super.initState();
    ioBase = widget.ioBase;
    /// 添加兼听 当TextFeild 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextFeild文本发生改变时才会回调
    textEditingController.addListener(() {
      ///获取输入的内容
      currentText = textEditingController.text;
      debugPrint(" controller 兼听设定内容 $currentText");
    });
  }

  @override
  void dispose() {
    saveText();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        saveText();
        currentBook = store.state.textModel.currentBook;
        currentSet = store.state.setModel.currentSet;
        currentSetting = store.state.setModel.currentSetting;
        textEditingController.text = getText();
        currentText = textEditingController.text;
        void renameSetting() {
          store.dispatch(SetSetDataAction(currentSet: currentSet, currentSetting: currentSetting));
        }
        return {
          "currentSet": currentSet,
          "currentSetting": currentSetting,
          "currentText": currentText,
          "renameSetting": renameSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            centerTitle: true,
            title: InkWell(
              child: Text(map["currentSetting"] ?? ""),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => ToastDialog(
                    title: '设定重命名',
                    init: currentSetting,
                    callBack: (strBack) => {
                      if (strBack.isNotEmpty)
                      {
                        changeSettingName(strBack),
                        map["renameSetting"](),
                      },
                    },
                  ),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: BlurGlass(
              marginValue: 0.0,
              paddingValue: 0.0,
              inBorderRadius: 0.0,
              outBorderRadius: 0.0,
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
          ),
        );
      },
    );
  }
}