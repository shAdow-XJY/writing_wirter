import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'file_configure.dart';

class UserIOBase
{
  /// 电脑文档目录路径
  late final String _appDocPath;

  UserIOBase() {
    getApplicationDocumentsDirectory().then((appDocDir) => {
      _appDocPath = appDocDir.path,
      _init(),
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                私有函数                                  //
  ////////////////////////////////////////////////////////////////////////////

  /// 构造函数内部使用：初始化函数
  void _init() {
    /// 创建应用文件夹
    Directory rootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.rootDirPath()}");
    if (!rootDir.existsSync()){
      rootDir.createSync(recursive: true);
      // debugPrint(_rootDir.path);
    }

    /// 创建应用子文件夹：导出文件夹
    Directory exportRootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportRootDirPath()}");
    if (!exportRootDir.existsSync()){
      exportRootDir.createSync(recursive: true);
    }
  }
}