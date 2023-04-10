import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

import '../../components/common/toast/global_toast.dart';
import '../../state_machine/event_bus/webDAV_events.dart';
import '../file/file_configure.dart';

class WebDAV {
  /// 电脑文档目录路径
  late final String _appDocPath;

  late EventBus _eventBus;

  WebDAV(EventBus eventBus) {
    _eventBus = eventBus;
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
      // debug: true,
    );
    try {
      await _client.ping();
      result = true;
      debugPrint("login successfully");
      // _eventBus.fire(WebDavLoginSuccessEvent());
      init();
    } catch (e) {
      debugPrint("login failed");
      // _eventBus.fire(WebDavLoginFailedEvent());
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
    debugPrint("webDAV init");
    _client.mkdir('/wWriter');
  }

  /// 获取所有云端的书籍：/wWriter/
  Future<List<Map<String, dynamic>>> getAllBooks() async {
    debugPrint("webDAV getAllBooks()");

    List<Map<String, dynamic>> books = [];
    try {
      List<webdav.File> list2 = await _client.readDir('/wWriter');
      for (var f in list2) {
        if (!(f.isDir??false)) {
          books.add({
            "name": f.name,
            "time": f.mTime,
          });
        }
      }
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取云端的书籍失败');
    }
    // _eventBus.fire(WebDavGetAllBooksEvent());
    return books;
  }

  /// 上传更新书籍到云端
  Future<void> uploadBook(String bookName) async {
    debugPrint("webDAV uploadBook()");
    try {
      _client.setHeaders({"content-type" : "application/zip"});
      await _client.writeFromFile(
        "$_appDocPath${Platform.pathSeparator}${FileConfig.webDAVLocalBookFilePath(bookName)}",
        FileConfig.webDAVBookFilePath(bookName),
        onProgress: (c, t) {
          // if (!((c/t) < 0.0)) {
          //   _eventBus.fire(WebDavUploadBookDoneEvent());
          // }
        },
      );
      _eventBus.fire(WebDavUploadBookDoneEvent());

      GlobalToast.showSuccessTop('更新云端书籍成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('更新云端书籍失败');
    }
  }

  /// 云端书籍下载到本地
  Future<void> downloadBook(String bookName) async {
    debugPrint("webDAV downloadBook()");
    try {
      _client.setHeaders({"content-type" : "application/zip"});
      await _client.read2File(
          FileConfig.webDAVBookFilePath(bookName),
          "$_appDocPath${Platform.pathSeparator}${FileConfig.webDAVLocalBookFilePath(bookName)}",
          onProgress: (c, t) {}
      );

      GlobalToast.showSuccessTop('云端书籍导入本地成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('云端书籍导入本地失败');
    }
  }

  /// 云端书籍删除
  Future<void> removeBook(String bookName) async {
    debugPrint("webDAV removeBook()");
    try {
      await _client.remove(FileConfig.webDAVBookFilePath(bookName));
      _eventBus.fire(WebDavRemoveBookDoneEvent());

      GlobalToast.showSuccessTop('云端书籍删除成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('云端书籍删除失败');
    }
  }
}