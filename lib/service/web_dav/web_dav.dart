import 'package:webdav_client/webdav_client.dart';
import 'package:writing_writer/service/file/IOBase.dart';

class WebDAV {
  Client client = newClient (
    'https://dav.jianguoyun.com/dav/',
    user: '1290232854@qq.com',
    password: 'avufw8khj233vep8',
    debug: true,
  );

  late final IOBase _ioBase;

  WebDAV(IOBase ioBase) {
    _ioBase = ioBase;
  }

  /// 书籍上传更新
  void upgradeBook(String bookName) {
    // client.writeFromFile(localFilePath, path)
  }

/// 书籍下载覆盖

/// 书籍删除
}