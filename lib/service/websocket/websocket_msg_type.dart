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
 * msgCode : 0
 * 状态通知信息
 * msgContent：
 * 状态码
 * 100 - 启动连接
 * 200 - 断开连接
 * */

/**
 * msgCode : 1
 * 传输数据信息
 * msgContent：
 * */
