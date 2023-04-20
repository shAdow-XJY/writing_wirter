import 'dart:async';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/toast/global_toast.dart';
import '../../../service/web_socket/web_socket_msg_type.dart';
import '../../../service/web_socket/web_socket_server.dart';
import '../../../state_machine/event_bus/ws_server_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class MobileSocketsPage extends StatefulWidget {
  const MobileSocketsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MobileSocketsPage> createState() => _PCSocketsPageState();
}

class _PCSocketsPageState extends State<MobileSocketsPage> {
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  /// webSocket 服务端
  late WebSocketServer webSocketServer;
  /// webSocket 服务端是否开启
  bool serverStatus = false;
  /// 当前显示的ip
  String serverIP = "";
  /// 定时查找是否网络IP更换
  late Timer _timer;
  /// 事件订阅器
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;
  late StreamSubscription subscription_3;
  late StreamSubscription subscription_4;

  /// 销毁服务器
  Future<void> closeServer() async {
    if (!appGetIt.isRegistered<WebSocketServer>(instanceName: "WebSocketServer")) {
      return;
    }
    webSocketServer.serverSendMsg(WebSocketMsg.msgString(msgCode: 2, msgTitle: "", msgContent: "", msgOffset: 0));
    webSocketServer.serverClose();
    await appGetIt.unregister<WebSocketServer>(instanceName: "WebSocketServer");
  }

  /// 重新建立服务器
  void rebuildServer() {
    appGetIt.registerSingleton<WebSocketServer>(WebSocketServer(eventBus), instanceName: "WebSocketServer");
    webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
  }

  @override
  void initState() {
    super.initState();
    if (!appGetIt.isRegistered<WebSocketServer>(instanceName: "WebSocketServer")) {
      appGetIt.registerSingleton<WebSocketServer>(WebSocketServer(eventBus), instanceName: "WebSocketServer");
    }
    webSocketServer = appGetIt.get(instanceName: "WebSocketServer");
    serverStatus = webSocketServer.serverStatus;
    serverIP = webSocketServer.serverIP;

    subscription_1 = eventBus.on<WSServerGetServerIPEvent>().listen((event) {
      webSocketServer.serverInit();
      setState(() {
        serverIP = webSocketServer.serverIP;
      });
    });
    subscription_2 = eventBus.on<WSServerStartWebSocketEvent>().listen((event) {
      GlobalToast.showSuccessTop('桌面端连接成功');
      Navigator.pop(context);
    });
    subscription_3 = eventBus.on<WSServerBuildServerEvent>().listen((event) {
      setState(() {
        serverStatus = webSocketServer.serverStatus;
      });
    });
    subscription_4 = eventBus.on<WSServerCloseServerEvent>().listen((event) {
      setState(() {
        serverStatus = webSocketServer.serverStatus;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      NetworkInterface.list(type: InternetAddressType.IPv4).then((value) => {
        if(value.first.addresses.first.address.toString().compareTo(serverIP) != 0) {
          closeServer(),
          rebuildServer(),
        }
      });
    });

  }

  @override
  void dispose() {
    _timer.cancel();
    subscription_1.cancel();
    subscription_2.cancel();
    subscription_3.cancel();
    subscription_4.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("点击手机端的同步写作，将显示的ip地址输入在下方："),
            Text(serverIP),
            Text(
              serverStatus ? "已启动" : "已断开"
            ),
            TextButton(
              child: const Text("refresh"),
              onPressed: () {
                closeServer();
                rebuildServer();
              },
            ),
            TextButton(
              child: const Text("close server"),
              onPressed: () {
                closeServer();
              },
            )
          ],
        ),
      )
    );
  }
}
