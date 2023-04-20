import 'dart:async';
import 'package:click_text_field/click_text_field.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/pages/common/chapter_edit_page/common_chapter_edit_body.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/ws_server_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
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
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");

  /// 全局单例-客户端webSocket
  late WebSocketServer webSocketServer;
  late StreamSubscription subscription_1;

  /// webSocket 传输的数据
  Map<String, dynamic> msgMap = {};

  /// 是否 webSocket 传过来导致的编辑内容改变
  bool isWebSocketReceive = false;

  /// 章节内容输入框控制器
  final ClickTextEditingController clickTextEditingController = ClickTextEditingController();

  /// 防抖发送数据包
  Timer? _timer;

  /// text
  String currentBook = "";
  String currentChapter = "";

  /// textEditingController的发送监听函数
  void sendListener() {
    // print("isWebSocketReceive$isWebSocketReceive");
    if (!isWebSocketReceive) {
      // print("isWebSocketReceive// 消息未发送成功");
      // 消息未发送成功
      if (_timer != null && _timer!.isActive) {
        // 重置定时器
        _timer?.cancel();
      }
      // 发送消息
      webSocketServer.serverSendMsg(WebSocketMsg.msgString(
        msgCode: 1,
        msgTitle: "$currentBook$currentChapter",
        msgContent: clickTextEditingController.text,
        msgOffset: clickTextEditingController.selection.baseOffset,
      ));
      // 设置定时器
      _timer = Timer(const Duration(milliseconds: 500), () {
        _timer = null;
        // 消息发送成功，重置状态
        isWebSocketReceive = false;
      });
    } else {
      // print("isWebSocketReceive// 消息已经发送成功，重置状态");
      // 消息已经发送成功，重置状态
      isWebSocketReceive = false;
    }
  }

  /// WebSocket的接收监听函数
  void receiveListener(dynamic msg) {
    isWebSocketReceive = true;
    msgMap = WebSocketMsg.msgStringToMap(msg);
    if ("$currentBook$currentChapter".compareTo(msgMap['msgTitle']) == 0) {
      clickTextEditingController.value = TextEditingValue(
        text: msgMap["msgContent"],
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: msgMap["msgOffset"],
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (appGetIt.isRegistered<WebSocketServer>(instanceName: "WebSocketServer")) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      clickTextEditingController.addListener(sendListener);
      webSocketServer.serverReceivedMsg(receiveListener);
    }
    subscription_1 = eventBus.on<WSServerStartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      clickTextEditingController.removeListener(sendListener);
      clickTextEditingController.addListener(sendListener);
      webSocketServer.serverReceivedMsg(receiveListener);
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    subscription_1.cancel();
    clickTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(converter: (Store store) {
      debugPrint('store in mobile_chapter_edit_page');
      currentBook = store.state.textModel.currentBook;
      currentChapter = store.state.textModel.currentChapter;
      return () => {};
    }, builder: (BuildContext context, VoidCallback voidCallback) {
      return CommonChapterEditPageBody(
        clickTextEditingController: clickTextEditingController,
      );
    });
  }
}
