import 'package:flutter/material.dart';

import '../../../service/websocket/websocket_client.dart';

class PCSocketsPage extends StatefulWidget {
  const PCSocketsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PCSocketsPage> createState() => _PCSocketsPageState();
}

class _PCSocketsPageState extends State<PCSocketsPage> {

  TextEditingController ipTextController = TextEditingController();

  late WebSocketClient webSocketClient;

  @override
  void initState() {
    super.initState();
    webSocketClient = WebSocketClient();
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
      body: Column(
              children: [
                const Text("点击手机端的同步写作，将显示的ip地址输入在下方："),
                TextField(
                  controller: ipTextController,
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
    );
  }
}
