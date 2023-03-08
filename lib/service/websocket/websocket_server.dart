import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

import '../../state_machine/event_bus/mobile_events.dart';

class WebSocketServer {
  /// 服务端
  late HttpServer _server;
  /// 服务端 webSocket
  late WebSocket _serverSocket;
  /// 接受消息处理函数，可由具体调用处自定义重写
  Function(dynamic msg) _serverReceived = (dynamic msg) {
    debugPrint(msg.toString());
  };
  /// 传入的事件总线
  late EventBus _eventBus;
  /// 建立服务器的ip
  String serverIP = "";
  int serverPort = 8090;
  /// 服务器启动状态
  bool serverStatus = false;

  WebSocketServer(EventBus eventBus) {
    NetworkInterface.list(type: InternetAddressType.IPv4).then((value) => {
      serverIP = value.first.addresses.first.address.toString(),
      _eventBus = eventBus,
      _eventBus.fire(MobileGetServerIPEvent()),
    });
  }

  /// 服务端启动
  void serverInit() async {
    // bind('127.0.0.1', 8090);
    debugPrint('服务器绑定IP $serverIP : $serverPort');
    _server = await HttpServer.bind(serverIP, serverPort);
    debugPrint('-------------移动端建立服务器成功-------------');
    serverStatus = true;
    _eventBus.fire(MobileBuildServerEvent());

    _server.listen((HttpRequest req) async {
      /// 监听"msg"数据
      debugPrint('-------------桌面客户端连接服务器成功-------------');
      if(WebSocketTransformer.isUpgradeRequest(req)) {
        await WebSocketTransformer.upgrade(req).then((webSocket) {
          webSocket.listen(_handleMsg);
          _serverSocket = webSocket;
          _eventBus.fire(MobileStartWebSocketEvent());
        });
      }
    });
  }

  /// 服务端关闭
  void serverClose() {
    serverStatus = false;
    _eventBus.fire(MobileCloseServerEvent());
    try {
      _serverSocket.close();
      debugPrint('webSocket 连接断开');
    } catch (e,s) {
      debugPrint('webSocket 不存在');
    }
    try {
      _server.close();
      debugPrint('http 连接断开');
    } catch (e,s) {
      debugPrint('http 不存在');
    }
  }

  /// 服务端 webSocket 监听函数
  void _handleMsg(dynamic msg) {
    debugPrint('收到客户端消息：${msg.toString()}');
    _serverReceived(msg);
  }

  /// 服务端发送消息
  void serverSendMsg(dynamic msg) {
    try {
      _serverSocket.add(msg);
    } catch (e,s) {
      debugPrint('webSocket 不存在');
    }
  }

  /// 调用处自定义接收到消息后的操作
  void serverReceivedMsg(Function(dynamic msg) receive) {
    _serverReceived = receive;
  }

}