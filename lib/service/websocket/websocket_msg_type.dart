import 'dart:convert';

class WebSocketMsg {

  static Map<String, dynamic> msgStringToMap(String msg) {
    return jsonDecode(msg);
  }

  static String msgString({required int msgCode, required String msgContent}) {
    Map<String, dynamic> msg = {
      "msgCode": msgCode,
      "msgContent": msgContent,
    };
    return jsonEncode(msg);
  }
}
/**
 * msgCode
 * 0 : server -> client
 * 1 : client -> server
 * */
