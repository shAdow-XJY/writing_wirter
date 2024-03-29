import 'dart:async';

import 'package:blur_glass/blur_glass.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/toast/global_toast.dart';

import '../../../service/web_socket/web_socket_client.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class PCSpaceEditPage extends StatefulWidget {
  const PCSpaceEditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCSpaceEditPage> createState() => _ChapterEditPageBodyState();
}

class _ChapterEditPageBodyState extends State<PCSpaceEditPage> {
  /// 全局单例-客户端webSocket
  final WebSocketClient webSocketClient = appGetIt.get(instanceName: "WebSocketClient");
  /// 章节内容输入框控制器
  final TextEditingController textEditingController = TextEditingController();
  /// webSocket 传输的数据
  Map<String,dynamic> msgMap = {};
  /// 是否 webSocket 传过来导致的编辑内容改变
  bool isWebSocketReceive = false;
  /// 防抖发送数据包
  Timer? _timer;
  /// msgTitle
  String msgTitle = '';

  @override
  void initState() {
    super.initState();
    webSocketClient.clientReceivedMsg((msg) => {
      isWebSocketReceive = true,
      msgMap = WebSocketMsg.msgStringToMap(msg),
      msgTitle = msgMap['msgTitle'],
      if (msgMap["msgCode"] == 2) {
        GlobalToast.showWarningTop('移动端断开连接'),
        Navigator.pop(context),
      } else {
        textEditingController.value = TextEditingValue(
          text: msgMap["msgContent"],
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream, offset: msgMap["msgOffset"],
            ),
          ),
        ),
      }
    });
    /// 添加兼听 当TextField 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextField文本发生改变时才会回调
    textEditingController.addListener(() {
      if (!isWebSocketReceive) {
        // 消息未发送成功
        if (_timer != null && _timer!.isActive) {
          // 重置定时器
          _timer?.cancel();
        }
        // 发送消息
        webSocketClient.clientSendMsg(WebSocketMsg.msgString(msgCode: 0, msgTitle: msgTitle, msgContent: textEditingController.text, msgOffset: textEditingController.selection.baseOffset,));
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
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    webSocketClient.clientClose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlurGlass(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        outBorderRadius: 0.0,
        inBorderRadius: 0.0,
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
    );
  }
}
