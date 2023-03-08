import 'dart:async';

import 'package:blur_glass/blur_glass.dart';
import 'package:click_text_field/click_text_field.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../service/file/IOBase.dart';
import '../../../service/parser/Parser.dart';
import '../../../service/websocket/websocket_msg_type.dart';
import '../../../service/websocket/websocket_server.dart';
import '../../../state_machine/event_bus/mobile_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/set_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

class MobileChapterEditPageBody extends StatefulWidget {
  const MobileChapterEditPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileChapterEditPageBody> createState() =>
      _MobileChapterEditPageBodyState();
}

class _MobileChapterEditPageBodyState extends State<MobileChapterEditPageBody> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt<IOBase>();
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt<EventBus>();
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

  /// 章节内容输入框控制器
  final ClickTextEditingController textEditingController =
  ClickTextEditingController();

  /// 输入框的内容
  String currentText = "";

  /// 输入框的焦点
  final FocusNode focusNode = FocusNode();

  /// text
  String currentBook = "";
  String currentChapter = "";

  /// set parser
  Map<String, Set<String>> currentParserObj = {};

  /// textEditingController点击高亮函数返回路径
  String getSetName(String settingClick) {
    String result = '';
    currentParserObj.forEach((setName, settingSet) {
      if (settingSet.contains(settingClick)) {
        result = setName;
      }
    });
    return result;
  }

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
    subscription_1 = eventBus.on<StartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      addWebSocketToListener();
    });
    /// 添加兼听 当TextField 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextField文本发生改变时才会回调
    textEditingController.addListener(() {
      ///获取输入的内容
      currentText = textEditingController.text;
    });

    /// 焦点失焦先保存文章内容
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        // TextField has lost focus
        saveText();
        debugPrint("失去焦点保存内容");
      }
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    saveText();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint('store in edit_sub_page');
        // 文本编辑
        saveText();
        currentBook = store.state.textModel.currentBook;
        currentChapter = store.state.textModel.currentChapter;
        if (getText().compareTo(textEditingController.text) != 0) {
          textEditingController.text = getText();
          currentText = textEditingController.text;
        }
        // 文本解析
        if (!Parser.compareParser(
            currentParserObj, store.state.parserModel.parserObj)) {
          currentParserObj = store.state.parserModel.parserObj;
        }
        void clickHighLightSetting(String settingClick) {
          String tempSet = getSetName(settingClick);
          if (tempSet.compareTo(store.state.setModel.currentSet) != 0 ||
              settingClick.compareTo(store.state.setModel.currentSetting) != 0) {
            store.dispatch(
              SetSetDataAction(
                currentSet: getSetName(settingClick),
                currentSetting: settingClick,
              ),
            );
          }
        }

        return {
          "clickHighLightSetting": clickHighLightSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return currentChapter.isEmpty
            ? const SizedBox()
            : BlurGlass(
          outBorderRadius: 0.0,
          child: ClickTextField(
            focusNode: focusNode,
            controller: textEditingController,
            regExp: Parser.generateRegExp(currentParserObj),
            onTapText: (String clickText) {
              map["clickHighLightSetting"](clickText);
            },
            decoration: const InputDecoration(
              /// 消除下边框
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
