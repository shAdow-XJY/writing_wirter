class WebSocketMsg {
  late final String msgCode;
  late final String msgContent;

  WebSocketMsg (
      this.msgCode,
      this.msgContent,
  );
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