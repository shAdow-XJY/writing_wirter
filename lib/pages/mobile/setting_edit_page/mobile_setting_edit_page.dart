import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/pages/common/setting_edit_page/common_setting_edit_page.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/ws_server_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class MobileSettingEditPage extends StatefulWidget {
  const MobileSettingEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileSettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<MobileSettingEditPage> {
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

  /// 设定内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();

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
    subscription_1 = eventBus.on<WSServerStartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      addWebSocketToListener();
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonSettingEditPage(textEditingController: textEditingController);
  }
}
