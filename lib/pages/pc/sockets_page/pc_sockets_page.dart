import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/components/common/toast/global_toast.dart';

import '../../../service/web_socket/web_socket_client.dart';
import '../../../state_machine/event_bus/ws_client_events.dart';
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
  late StreamSubscription subscription_2;

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

    subscription_1 = eventBus.on<WSClientConnectServerSuccessEvent>().listen((event) {
      GlobalToast.showSuccessTop('连接移动端成功');
      Navigator.pushNamed(context, '/space');
    });
    subscription_2 = eventBus.on<WSClientConnectServerErrorEvent>().listen((event) {
      GlobalToast.showWarningTop('IP地址连接无响应，请确定移动端已启动同步');
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    subscription_2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      insetPadding: const EdgeInsets.symmetric(vertical: 150.0, horizontal: 220.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColorDark],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("点击手机端的同步写作，将显示的ip地址输入在下方："),
              TextFormField(
                controller: ipTextController,
                decoration: const InputDecoration(
                  labelText: "IP地址",
                  hintText: "请输入移动端显示的IP地址",
                  icon: Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 16.0,),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                      child: TextButton(
                        child: const Text("确定"),
                        onPressed: () {
                          webSocketClient.clientConnect(ipTextController.text);
                        },
                      ),
                  ),
                  const Expanded(flex: 2 ,child: SizedBox()),
                  Expanded(
                      child: TextButton(
                        child: const Text("取消"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
