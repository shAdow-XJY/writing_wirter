import 'dart:io';
import 'package:flutter/cupertino.dart';

class WebSocketServer {
  /// 服务端
  late HttpServer server;
  /// 服务端 webSocket
  late WebSocket serverSocket;
  /// 接受消息处理函数，可由具体调用处自定义
  late Function(String msg) serverReceived;

  String serverIP = "";

  WebSocketServer() {
    NetworkInterface.list(type: InternetAddressType.IPv4).then((value) => {
      serverIP = value.first.addresses.first.address.toString(), //_allIPv4[0],
    });
  }

  /// 服务端操作
  void serverBind(String ip, int port) async {
    // bind('127.0.0.1', 8090);
    debugPrint('服务器绑定IP $ip : $port');
    server = await HttpServer.bind(ip, port);
    debugPrint('-------------服务器绑定成功-------------');

    server.listen((HttpRequest req) async {
      /// 监听"msg"数据
      debugPrint('-------------服务器监听成功-------------');
      if(WebSocketTransformer.isUpgradeRequest(req)){
        await WebSocketTransformer.upgrade(req).then((webSocket){
          webSocket.listen(handleMsg);
          serverSocket = webSocket;
        });
      }
    });
  }

  /// 服务端 webSocket 监听函数
  void handleMsg(dynamic msg){
    debugPrint('收到客户端消息：${msg.toString()}');
    serverReceived(msg);
  }

  /// 服务端发送消息
  void serverSendMsg(String msg) {
    serverSocket.add(msg);
  }

  /// 调用处自定义接收到消息后的操作
  void serverReceivedMsg(Function(String msg) receive) {
    serverReceived = receive;
  }
}