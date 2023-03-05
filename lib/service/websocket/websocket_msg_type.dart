import 'dart:convert';

class WebSocketMsg {

  static Map<String, dynamic> msgStringToMap(String msg) {
    return jsonDecode(msg);
  }

  static String msgString({required int msgCode, required String msgContent, required int msgOffset}) {
    Map<String, dynamic> msg = {
      "msgCode": msgCode,
      "msgContent": msgContent,
      "msgOffset": msgOffset,
    };
    return jsonEncode(msg);
  }
}
/**
 * msgCode ： 传输的code
 * 0 : server -> client
 * 1 : client -> server
 * 2 : server 断开
 *
 * msgContent : 传输的字符串数据
 *
 * msgOffset : 字符串选择偏移
 * */
