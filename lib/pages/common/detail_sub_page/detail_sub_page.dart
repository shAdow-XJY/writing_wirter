import 'package:blur_glass/blur_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/transparent_icon_button.dart';
import 'dart:convert' as convert;
import '../../../components/common/drop_down_button.dart';
import '../../../components/common/toast_dialog.dart';
import '../../../server/file/IOBase.dart';
import '../../../state_machine/redux/action/set_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

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

  /// status 状态变量
  String currentBook = "";
  String currentSet = "";
  String currentSetting = "";

  /// {json}设定的内容
  Map<String, dynamic> currentMap = {};

  /// {json {chapterFlag }}
  /// 标志章节数组
  List<String> chapterFlags = [];
  /// {json {information {description }}}
  /// 输入框的内容
  String currentDescription = "";
  /// 设定内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();
  /// 输入框的焦点
  final focusNode = FocusNode();

  /// 获取设定
  void getSetting() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return ;
    }
    currentMap = ioBase.getSettingJson(currentBook, currentSet, currentSetting);
    chapterFlags = currentMap["chapterFlag"].cast<String>()??[];
    textEditingController.text = currentMap["information"]![0]["description"];
    currentDescription = textEditingController.text;
  }

  /// 保存/更新设定
  void saveSetting() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return;
    }
    if (currentMap.isEmpty) {
      return;
    }
    currentMap["information"][0]["description"] = currentDescription;
    ioBase.saveSetting(currentBook, currentSet, currentSetting, convert.jsonEncode(currentMap));
  }

  /// 设定重命名
  void changeSettingName(String newSettingName) {
    if (newSettingName.compareTo(currentSetting) == 0) {
      return;
    }
    // 先保存再重命名设定.json文件
    ioBase.saveSetting(currentBook, currentSet, currentSetting, currentDescription);
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
      currentDescription = textEditingController.text;
      debugPrint(" controller 监听设定内容 $currentDescription");
    });
    /// 焦点失焦先保存文章内容
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // TextField has lost focus
        saveSetting();
        debugPrint("失去焦点保存内容");
      }
    });
  }

  @override
  void dispose() {
    saveSetting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        saveSetting();
        currentBook = store.state.textModel.currentBook;
        currentSet = store.state.setModel.currentSet;
        currentSetting = store.state.setModel.currentSetting;
        getSetting();
        void renameSetting() {
          store.dispatch(SetSetDataAction(currentSet: currentSet, currentSetting: currentSetting));
        }
        return {
          "currentSet": currentSet,
          "currentSetting": currentSetting,
          "currentDescription": currentDescription,
          "renameSetting": renameSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('第'),
                  DropDownButton(
                    items: chapterFlags,
                    onChanged: (String selected) {
                      debugPrint(selected);
                    },
                  ),
                  const Text('章'),
                  TransIconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ToastDialog(
                            title: '新建设定节点',
                            callBack: (flagChapter) => {
                              if (flagChapter.isNotEmpty) {

                              },
                            },
                          ),
                        );
                      },
                  )
                ],
              )
            ],
          ),
          body: SingleChildScrollView(
            child: BlurGlass(
              marginValue: 0.0,
              paddingValue: 0.0,
              inBorderRadius: 0.0,
              outBorderRadius: 0.0,
              child: TextField(
                maxLines: null,
                focusNode: FocusNode(),
                controller: textEditingController,
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