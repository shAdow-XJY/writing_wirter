class WebSocketMsg {
  final String msgCode;
  final String msgContent;

  WebSocketMsg({
    required this.msgCode,
    required this.msgContent,
  });
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
