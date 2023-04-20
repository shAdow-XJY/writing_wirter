import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/pages/common/setting_edit_page/common_setting_edit_page.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/ws_server_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';

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

  /// 事件订阅器
  late StreamSubscription subscription_1;

  /// webSocket 传输的数据
  Map<String, dynamic> msgMap = {};

  /// 是否 webSocket 传过来导致的编辑内容改变
  bool isWebSocketReceive = false;

  /// 设定内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  /// 编辑的状态变量
  String currentSet = "";
  String currentSetting = "";

  /// 防抖发送数据包
  Timer? _timer;

  /// textEditingController的发送监听函数
  void sendListener() {
    if (!isWebSocketReceive) {
      // 消息未发送成功
      if (_timer != null && _timer!.isActive) {
        // 重置定时器
        _timer?.cancel();
      }
      // 发送消息
      webSocketServer.serverSendMsg(WebSocketMsg.msgString(
        msgCode: 1,
        msgTitle: "$currentSet$currentSetting",
        msgContent: textEditingController.text,
        msgOffset: textEditingController.selection.baseOffset,
      ));
      // 设置定时器
      _timer = Timer(const Duration(milliseconds: 500), () {
        _timer = null;
        // 消息发送成功，重置状态
        isWebSocketReceive = false;
      });
    } else {
      // 消息已经发送成功，重置状态
      isWebSocketReceive = false;
    }
  }

  /// WebSocket的接收监听函数
  void receiveListener(dynamic msg) {
    isWebSocketReceive = true;
    msgMap = WebSocketMsg.msgStringToMap(msg);
    if ("$currentSet$currentSetting".compareTo(msgMap['msgTitle']) == 0) {
      textEditingController.value = TextEditingValue(
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
      textEditingController.addListener(sendListener);
      webSocketServer.serverReceivedMsg(receiveListener);
    }
    subscription_1 = eventBus.on<WSServerStartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      textEditingController.removeListener(sendListener);
      textEditingController.addListener(sendListener);
      webSocketServer.serverReceivedMsg(receiveListener);
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    subscription_1.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(converter: (Store store) {
      debugPrint('store in mobile_setting_edit_page');
      currentSet = store.state.setModel.currentSet;
      currentSetting = store.state.setModel.currentSetting;
      return () => {};
    }, builder: (BuildContext context, VoidCallback voidCallback) {
      return CommonSettingEditPage(
          textEditingController: textEditingController);
    });
  }
}
