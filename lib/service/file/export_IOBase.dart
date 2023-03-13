import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'IOBase.dart';
import 'file_configure.dart';

class ExportIOBase
{
  /// 电脑文档目录路径
  late final Directory _appDocDir;
  late final String _appDocPath;

  /// writing writer 根文件夹
  late final Directory _rootDir;
  /// writing writer 根路径
  late final String _rootPath;
  /// writing writer 根文件夹名称
  final String _rootName = FileConfig.rootName;

  /// writing writer 导出内容文件夹
  late final Directory _exportRootDir;
  /// writing writer 导出内容文件夹路径
  late final String _exportRootPath;
  /// writing writer 导出内容文件夹名称
  final String _exportRootName = FileConfig.exportRootName;

  /// IOBase
  late final IOBase _ioBase;

  ExportIOBase(IOBase ioBase) {
    _ioBase = ioBase;
    getApplicationDocumentsDirectory().then((appDocDir) => {
      _appDocDir = appDocDir,
      _appDocPath = _appDocDir.path,
      _init(),
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                私有函数                                  //
  ////////////////////////////////////////////////////////////////////////////

  /// 构造函数内部使用：初始化函数
  void _init() {
    /// 创建应用文件夹
    _rootDir = Directory(_appDocPath + Platform.pathSeparator + _rootName);
    if (!_rootDir.existsSync()){
      _rootDir.createSync(recursive: true);
      // debugPrint(_rootDir.path);
    }
    _rootPath = _rootDir.path;

    /// 创建应用子文件夹：导出文件夹
    _exportRootDir = Directory(_rootPath + Platform.pathSeparator + _exportRootName);
    if (!_exportRootDir.existsSync()){
      _exportRootDir.createSync(recursive: true);
    }
    _exportRootPath = _exportRootDir.path;
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                私有函数                                  //
  ////////////////////////////////////////////////////////////////////////////
}