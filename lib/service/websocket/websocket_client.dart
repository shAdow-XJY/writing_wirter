import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  /// 客户端 webSocket
  late IOWebSocketChannel clientSocket;
  /// 接受消息处理函数，可由具体调用处自定义
  late Function(String msg) clientReceived;

  int serverPort = 8090;
  
  /// 客户端操作
  void clientConnect(String ip) async {
    try {
      clientSocket = IOWebSocketChannel.connect(Uri.parse('ws://$ip:${serverPort.toString()}'));
      clientSocket.stream.listen((msg){
        handleMsg(msg);
      });
    } catch (e,s) {

    }
  }

  /// 客户端关闭
  void serverClose(){
    clientSocket.sink.close();
  }

  /// 客户端 webSocket 监听函数
  void handleMsg(dynamic msg){
    debugPrint('收到服务端消息：${msg.toString()}');
    clientReceived(msg);
  }

  /// 服务端发送消息
  void clientSendMsg(String msg) {
    clientSocket.sink.add(msg);
  }

  /// 调用处自定义接收到消息后的操作
  void clientReceivedMsg(Function(String msg) receive) {
    clientReceived = receive;
  }
}