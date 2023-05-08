import 'dart:async';

import 'package:blur_glass/blur_glass.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/buttons/transparent_icon_button.dart';
import 'dart:convert' as convert;
import '../../../components/common/buttons/drop_down_button.dart';
import '../../../components/common/dialog/number_edit_dialog.dart';
import '../../../components/common/dialog/text_toast_dialog.dart';
import '../../../components/common/toast/global_toast.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';

class CommonSettingEditPage extends StatefulWidget {
  final TextEditingController textEditingController;
  const CommonSettingEditPage({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  State<CommonSettingEditPage> createState() => _CommonSettingEditPageState();
}

class _CommonSettingEditPageState extends State<CommonSettingEditPage> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");

  /// status 状态变量
  String currentBook = "";
  String currentChapterNumber = "";
  String currentSet = "";
  String currentSetting = "";

  /// {json}设定的内容
  Map<String, dynamic> currentMap = {};

  /// {json {chapterFlag }}
  /// 标志章节数组
  List<String> chapterFlags = []; // ["1","2"]
  List<String> chapterFlagsShow = []; // ["1~2","2~"];
  int currentFlagIndex = 0;
  
  /// {json {information {description }}}
  /// 输入框的内容
  String currentDescription = "";
  /// 设定内容输入框控制器
  late final TextEditingController textEditingController;
  /// 输入框的焦点
  final focusNode = FocusNode();

  /// 获取设定json
  void getSetting() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return;
    }
    currentMap = ioBase.getSettingJson(currentBook, currentSet, currentSetting);
    chapterFlags = currentMap["chapterFlags"].cast<String>();
    chapterFlagShowChange();
    currentFlagIndexChange(currentChapterNumber);
  }
  
  /// 保存/更新设定json
  void saveSetting() {
    if (currentBook.isEmpty || currentSet.isEmpty || currentSetting.isEmpty) {
      return;
    }
    if (currentMap.isEmpty) {
      return;
    }
    currentMap["chapterFlags"] = chapterFlags;
    currentMap["information"][currentFlagIndex]["description"] = currentDescription;
    ioBase.saveSetting(currentBook, currentSet, currentSetting, convert.jsonEncode(currentMap));
  }

  /// chapterFlagShow 处理
  void chapterFlagShowChange() {
    chapterFlagsShow.clear();
    for (var index = 0; index < chapterFlags.length; ++index) {
      String tmpStr = chapterFlags[index];
      tmpStr += "~";
      tmpStr += index+1 <= chapterFlags.length-1
          ? (int.parse(chapterFlags[index+1])-1).toString()
          : "";
      chapterFlagsShow.add(tmpStr);
    }
  }

  /// currentFlagIndex 处理：初始化和新建
  void currentFlagIndexChange(String chapterNumber, {bool insertNewFlag = false}) {
    List<int> chapterNumList = [];
    for (var index = 0; index < chapterFlags.length; ++index) {
      chapterNumList.add(int.parse(chapterFlags[index]));
    }
    int nowChapterNum = int.parse(chapterNumber);
    currentFlagIndex = 0;
    for (var index = 0; index < chapterNumList.length; ++index) {
      if (nowChapterNum >= chapterNumList[index]) {
        currentFlagIndex = index;
      } else {
        break;
      }
    }
    if (insertNewFlag) {
      ++currentFlagIndex;
      chapterFlags.insert(currentFlagIndex, chapterNumber);
      currentMap["information"].insert(currentFlagIndex, convert.jsonDecode(convert.jsonEncode(currentMap["information"][currentFlagIndex-1])));
      chapterFlagShowChange();
    }
    descriptionChange();
  }

  /// currentFlagIndex 处理：删除
  void currentFlagIndexRemove() {
    chapterFlags.removeAt(currentFlagIndex);
    currentMap["information"].removeAt(currentFlagIndex);
    --currentFlagIndex;
    chapterFlagShowChange();
    descriptionChange();
  }

  /// Description 处理
  void descriptionChange() {
    textEditingController.text = currentMap["information"][currentFlagIndex]["description"];
    currentDescription = textEditingController.text;
  }

  /// 节流Timer：定时保存
  Timer? _throttleTimer;
  void throttleSaveSetting() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(seconds: 15), () {
      _throttleTimer = null;
      saveSetting();
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController = widget.textEditingController;
    /// 添加兼听 当TextField 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextField文本发生改变时才会回调
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
        _throttleTimer?.cancel();
      } else {
        throttleSaveSetting();
      }
    });
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    saveSetting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>> (
      converter: (Store store) {
        debugPrint("store in common_setting_edit_page");
        saveSetting();
        currentBook = store.state.textModel.currentBook;
        currentSet = store.state.setModel.currentSet;
        if (currentSetting.compareTo(store.state.setModel.currentSetting) != 0) {
          currentChapterNumber = store.state.textModel.currentChapterNumber;
          currentSetting = store.state.setModel.currentSetting;
          getSetting();
        }
        return {
          "currentSet": currentSet,
          "currentSetting": currentSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return map["currentSetting"].toString().isEmpty
            ? Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: const Text('no setting selected'),
                ),
              )
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(map["currentSetting"]),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColorDark],
                          ),
                        ),
                        child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(
                            child: Text('章节范围'),
                          ),
                          Flexible(
                            flex: 5,
                            child: DropDownButton(
                              initIndex: currentFlagIndex,
                              items: chapterFlagsShow,
                              onChanged: (String selected) {
                                saveSetting();
                                final String selectedFlag = selected.split('~').first;
                                eventBus.fire(SettingFlagChangeEvent(selectedFlag: selectedFlag));
                                setState(() {
                                  currentFlagIndexChange(selectedFlag);
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: TransIconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => NumberEditDialog(
                                    title: '新建设定节点',
                                    callBack: (String flagChapterNumber) => {
                                      if (!chapterFlags.contains(flagChapterNumber))
                                        {
                                          setState(() {
                                            saveSetting();
                                            currentFlagIndexChange(flagChapterNumber, insertNewFlag: true);
                                          }),
                                          Navigator.pop(context),
                                        } else {
                                        GlobalToast.showErrorTop('该设定节点$flagChapterNumber已存在',),
                                      },
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Flexible(
                            child: TransIconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => TextToastDialog(
                                    title: '删除设定节点',
                                    text: '确定删除当前设定结点 ${chapterFlags[currentFlagIndex]} ?',
                                    callBack: () {
                                      if (currentFlagIndex != 0) {
                                        setState(() {
                                          currentFlagIndexRemove();
                                          saveSetting();
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        GlobalToast.showErrorTop('设定节点 1 不支持删除',);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ),
                      BlurGlass(
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
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              );
      },
    );
  }
}
