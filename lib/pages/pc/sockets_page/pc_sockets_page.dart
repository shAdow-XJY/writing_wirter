import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../service/web_socket/web_socket_client.dart';
import '../../../state_machine/event_bus/pc_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class PCSocketsPage extends StatefulWidget {
  const PCSocketsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCSocketsPage> createState() => _PCSocketsPageState();
}

class _PCSocketsPageState extends State<PCSocketsPage> {
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;

  TextEditingController ipTextController = TextEditingController();

  late WebSocketClient webSocketClient;

  @override
  void initState() {
    super.initState();
    if (!appGetIt.isRegistered<WebSocketClient>(instanceName: "WebSocketClient")) {
      appGetIt.registerSingleton<WebSocketClient>(WebSocketClient(eventBus), instanceName: "WebSocketClient");
    }
    webSocketClient = appGetIt.get(instanceName: "WebSocketClient");

    ipTextController.text = webSocketClient.inputIp;

    subscription_1 = eventBus.on<PCConnectServerSuccessEvent>().listen((event) {
      Navigator.pushNamed(context, '/space');
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 220.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("点击手机端的同步写作，将显示的ip地址输入在下方："),
            TextField(
              controller: ipTextController,
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: const Text("确定"),
              onPressed: () {
                webSocketClient.clientConnect(ipTextController.text);
              },
            ),
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
