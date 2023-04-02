import 'package:dio/dio.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class WebDAV {
  late webdav.Client _client;

  /// webDAV 登录
  Future<bool> login(String uri, String user, String password) async {
    bool result = false;

    _client = webdav.newClient (
      uri,
      user: user,
      password: password,
    );
    try {
      await _client.ping();
      result = true;
      init();
    } catch (e) {
      print('$e');
    }

    return result;
  }

  /// 关闭连接
  void close() {
    _client.c.close();
  }

  /// 初始化文件夹：/wWriter
  void init() {
    _client.mkdir('/wWriter');
  }

  /// 获取所有云端的书籍：/wWriter/
  Future<List<Map<String, dynamic>>> getAllBooks() async {
    List<webdav.File> list2 = await _client.readDir('/wWriter');
    List<Map<String, dynamic>> books = [];
    for (var f in list2) {
      print('${f.name} ${f.path} ${f.cTime} ${f.mTime}');
      if (!(f.isDir??false)) {
        books.add({
          "name": f.name,
          "time": f.mTime,
        });
      }
    }
    return books;
  }

  /// 上传更新书籍到云端
  Future<void> uploadBook(String bookName) async {
    // upload local file 2 remote file with stream
    CancelToken cancelToken = CancelToken();
    await _client.writeFromFile(
      'C:/Users/xxx/vpn.exe',
      '/f/vpn2.exe',
      onProgress: (c, t) {
        print(c / t);
      },
      cancelToken: cancelToken,
    );
  }

/// 书籍下载覆盖

/// 书籍删除
}