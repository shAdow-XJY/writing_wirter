import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import '../../state_machine/event_bus/ws_client_events.dart';

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
        connectTimeout: const Duration(milliseconds: 150),
      );

      Timer(const Duration(milliseconds: 150), () {
        if (_clientSocketChannel.innerWebSocket == null) {
          _eventBus.fire(WSClientConnectServerErrorEvent());
        }
        else {
          _eventBus.fire(WSClientConnectServerSuccessEvent());
          _clientSocketChannel.stream.listen((msg){
            _handleMsg(msg);
          });
        }
      });
    } catch (e,s) {
      debugPrintStack(stackTrace: s);
      _eventBus.fire(WSClientConnectServerErrorEvent());
    }
  }

  /// 客户端关闭
  void clientClose(){
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