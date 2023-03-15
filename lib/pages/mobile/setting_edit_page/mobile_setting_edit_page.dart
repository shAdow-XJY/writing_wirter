import 'dart:async';

import 'package:blur_glass/blur_glass.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/transparent_icon_button.dart';
import 'dart:convert' as convert;
import '../../../components/common/drop_down_button.dart';
import '../../../components/common/toast_dialog.dart';
import '../../../service/file/IOBase.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/mobile_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/set_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

class MobileSettingEditPage extends StatefulWidget {
  const MobileSettingEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileSettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<MobileSettingEditPage> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  /// 全局单例-客户端webSocket
  late WebSocketServer webSocketServer;
  /// 是否 textEditingController 的监听函数已完成设置
  bool isAddWebSocketToListener = false;
  /// 事件订阅器
  late StreamSubscription subscription_1;
  /// webSocket 传输的数据
  Map<String, dynamic> msgMap = {};
  /// 是否 webSocket 传过来导致的编辑内容改变
  bool isWebSocketReceive = false;

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
  final TextEditingController textEditingController = TextEditingController();
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
    currentMap["information"][currentFlagIndex]["description"] = currentDescription;
    ioBase.saveSetting(currentBook, currentSet, currentSetting, convert.jsonEncode(currentMap));
  }

  /// 设定json重命名
  void changeSettingName(String newSettingName) {
    if (newSettingName.compareTo(currentSetting) == 0) {
      return;
    }
    // 先保存再重命名设定.json文件
    ioBase.saveSetting(currentBook, currentSet, currentSetting, currentDescription);
    ioBase.renameSetting(currentBook, currentSet, currentSetting, newSettingName);
    currentSetting = newSettingName;
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

  /// currentFlagIndex 处理
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

  /// Description 处理
  void descriptionChange() {
    textEditingController.text = currentMap["information"][currentFlagIndex]["description"];
    currentDescription = textEditingController.text;
  }

  /// textEditingController 的webSocket监听函数已完成设置
  void addWebSocketToListener() {
    if (isAddWebSocketToListener) {
      return;
    }
    textEditingController.addListener(() {
      if (!isWebSocketReceive) {
        webSocketServer.serverSendMsg(WebSocketMsg.msgString(msgCode: 1, msgContent: textEditingController.text, msgOffset: textEditingController.selection.baseOffset));
      } else {
        isWebSocketReceive = false;
      }
    });

    webSocketServer.serverReceivedMsg((msg) => {
      isWebSocketReceive = true,
      msgMap = WebSocketMsg.msgStringToMap(msg),
      textEditingController.value = TextEditingValue(
        text: msgMap["msgContent"],
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: msgMap["msgOffset"],
          ),
        ),
      ),
    });
  }

  @override
  void initState() {
    super.initState();
    if (appGetIt.isRegistered<WebSocketServer>(instanceName: "WebSocketServer")) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      addWebSocketToListener();
      isAddWebSocketToListener = true;
    }
    subscription_1 = eventBus.on<MobileStartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      addWebSocketToListener();
    });
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
    subscription_1.cancel();
    saveSetting();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint("store in mobile_setting_edit_page");
        saveSetting();
        currentBook = store.state.textModel.currentBook;
        currentSet = store.state.setModel.currentSet;
        if (currentSetting.compareTo(store.state.setModel.currentSetting) != 0) {
          currentChapterNumber = store.state.textModel.currentChapterNumber;
          currentSetting = store.state.setModel.currentSetting;
          getSetting();
        }
        void renameSetting() {
          store.dispatch(SetSetDataAction(currentSet: currentSet, currentSetting: currentSetting));
        }
        return {
          "currentSet": currentSet,
          "currentSetting": currentSetting,
          "renameSetting": renameSetting,
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
                  title: InkWell(
                    child: Text(map["currentSetting"]),
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
                          initIndex: currentFlagIndex,
                          items: chapterFlagsShow,
                          onChanged: (String selected) {
                            saveSetting();
                            setState(() {
                              currentFlagIndexChange(selected.split('~').first);
                            });
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
                                  if (flagChapter.isNotEmpty)
                                  {
                                    setState(() {
                                      saveSetting();
                                      currentFlagIndexChange(flagChapter, insertNewFlag: true);
                                    }),
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
