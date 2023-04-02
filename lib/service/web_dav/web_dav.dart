import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

import '../file/file_configure.dart';

class WebDAV {
  /// 电脑文档目录路径
  late final String _appDocPath;

  WebDAV() {
    getApplicationDocumentsDirectory().then((appDocDir) => {
      _appDocPath = appDocDir.path,
    });
  }

  late webdav.Client _client;

  /// webDAV 登录
  Future<bool> login(String uri, String user, String password) async {
    bool result = false;

    _client = webdav.newClient (
      uri,
      user: user,
      password: password,
      debug: true,
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
    _client.setHeaders({"content-type" : "application/zip"});

    await _client.writeFromFile(
      "$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookZipFilePath(bookName)}",
      FileConfig.webDAVBookFilePath(bookName),
      onProgress: (c, t) {
        print(c);
        print(t);
        print(c / t);
      },
    );
  }

/// 书籍下载覆盖

/// 书籍删除
}