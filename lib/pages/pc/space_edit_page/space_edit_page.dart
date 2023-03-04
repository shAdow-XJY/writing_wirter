import 'package:blur_glass/blur_glass.dart';
import 'package:flutter/material.dart';

import '../../../service/websocket/websocket_client.dart';
import '../../../service/websocket/websocket_msg_type.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class SpaceEditPage extends StatefulWidget {
  const SpaceEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SpaceEditPage> createState() => _ChapterEditPageBodyState();
}

class _ChapterEditPageBodyState extends State<SpaceEditPage> {
  /// 全局单例-客户端webSocket
  final WebSocketClient webSocketClient = appGetIt.get(instanceName: "WebSocketClient");
  /// webSocket 传输的数据
  Map<String,dynamic> msgMap = {};
  /// 是否 webSocket 传过来导致的编辑内容改变
  bool isWebSocketReceive = false;

  /// 章节内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    webSocketClient.clientReceivedMsg((msg) => {
      isWebSocketReceive = true,
      msgMap = WebSocketMsg.msgStringToMap(msg),
      textEditingController.value = TextEditingValue(
        text: msgMap["msgContent"],
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream, offset: msgMap["msgContent"].length,
          ),
        ),
      ),
    });
    /// 添加兼听 当TextField 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextField文本发生改变时才会回调
    textEditingController.addListener(() {
      if (!isWebSocketReceive) {
        webSocketClient.clientSendMsg(WebSocketMsg.msgString(msgCode: 1, msgContent: textEditingController.text));
      } else {
        isWebSocketReceive = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurGlass(
        child: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(
            /// 消除下边框
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
