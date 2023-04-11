import 'dart:async';
import 'package:click_text_field/click_text_field.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/pages/common/chapter_edit_page/common_chapter_edit_body.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/ws_server_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class MobileChapterEditPageBody extends StatefulWidget {
  const MobileChapterEditPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileChapterEditPageBody> createState() => _MobileChapterEditPageBodyState();
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

  @override
  void initState() {
    super.initState();
    subscription_1 = eventBus.on<WSServerStartWebSocketEvent>().listen((event) {
      webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
      clickTextEditingController.addListener(() {
        if (!isWebSocketReceive) {
          webSocketServer.serverSendMsg(WebSocketMsg.msgString(msgCode: 1, msgContent: clickTextEditingController.text, msgOffset: clickTextEditingController.selection.baseOffset));
        } else {
          isWebSocketReceive = false;
        }
      });

      webSocketServer.serverReceivedMsg((msg) => {
        isWebSocketReceive = true,
        msgMap = WebSocketMsg.msgStringToMap(msg),
        clickTextEditingController.value = TextEditingValue(
          text: msgMap["msgContent"],
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: msgMap["msgOffset"],
            ),
          ),
        ),
      });
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    clickTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonChapterEditPageBody(clickTextEditingController: clickTextEditingController,);
  }
}
