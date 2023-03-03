import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import '../../../service/websocket/websocket_server.dart';
import '../../../state_machine/event_bus/mobile_events.dart';
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
  final EventBus eventBus = appGetIt<EventBus>();

  late WebSocketServer webSocketServer;

  String serverIP = "";

  /// 重新建立服务器
  Future<void> refreshIP() async {
    webSocketServer.serverClose();
    await appGetIt.unregister<WebSocketServer>(instanceName: "WebSocketServer");
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
    serverIP = webSocketServer.serverIP;

    eventBus.on<GetServerIPEvent>().listen((event) {
      webSocketServer.serverInit();
      setState(() {
        serverIP = webSocketServer.serverIP;
      });
    });

    eventBus.on<StartWebSocketEvent>().listen((event) {
      Navigator.pop(context);
    });
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
            TextButton(
              child: const Text("refresh"),
              onPressed: () {
                refreshIP();
              },
            )
          ],
        ),
      )
    );
  }
}
