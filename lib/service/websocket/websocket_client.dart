import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import '../../state_machine/event_bus/pc_events.dart';

class WebSocketClient {
  /// 客户端 webSocketChannel
  late IOWebSocketChannel _clientSocketChannel;
  /// 接受消息处理函数，可由具体调用处自定义
  late Function(String msg) clientReceived;

  late EventBus _eventBus;
  String inputIp = "";
  final int _serverPort = 8090;

  WebSocketClient(EventBus eventBus) {
    _eventBus = eventBus;
  }

  /// 客户端操作
  void clientConnect(String ip) async {
    inputIp = ip;
    try {
      _clientSocketChannel =  IOWebSocketChannel.connect(
        Uri.parse('ws://$ip:${_serverPort.toString()}'),
        connectTimeout: const Duration(seconds: 3),
      );

      Timer(const Duration(seconds: 3), () {
        if (_clientSocketChannel.innerWebSocket == null) {
          _eventBus.fire(ConnectServerErrorEvent());
        }
        else {
          _eventBus.fire(ConnectServerSuccessEvent());
          _clientSocketChannel.stream.listen((msg){
            _handleMsg(msg);
          });
        }
      });
    } catch (e,s) {
      _eventBus.fire(ConnectServerErrorEvent());
    }
  }

  /// 客户端关闭
  void serverClose(){
    _clientSocketChannel.sink.close();
  }

  /// 客户端 webSocket 监听函数
  void _handleMsg(dynamic msg){
    debugPrint('收到服务端消息：${msg.toString()}');
    clientReceived(msg);
  }

  /// 服务端发送消息
  void clientSendMsg(dynamic msg) {
    _clientSocketChannel.sink.add(msg);
  }

  /// 调用处自定义接收到消息后的操作
  void clientReceivedMsg(Function(dynamic msg) receive) {
    clientReceived = receive;
  }
}