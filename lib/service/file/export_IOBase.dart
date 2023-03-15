import 'dart:io';
import 'package:archive/archive_io.dart';
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

  /// writing writer 写作内容文件夹名称
  final String _writeRootName = FileConfig.writeRootName;

  /// writing writer 导出内容文件夹
  late final Directory _exportRootDir;
  /// writing writer 导出内容文件夹路径
  late final String _exportRootPath;
  /// writing writer 导出内容文件夹名称
  final String _exportRootName = FileConfig.exportRootName;
  /// writing writer 导出内容子文件夹名称
  final String _exportChapterDirName = FileConfig.exportChapterDirName;
  final String _exportBookDirName = FileConfig.exportBookDirName;
  final String _exportZipDirName = FileConfig.exportZipDirName;
  
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

  /// 目录路径统一生成函数
  String _inputDirPath({String bookName = ""}) {
    String path = "$_rootPath${Platform.pathSeparator}$_writeRootName${Platform.pathSeparator}$bookName";
    return path;
  }

  String _outputDirPath({String bookName = "", bool isOutChapter = false, bool isOutBook = false, bool isOutZip = false}) {
    String path = "$_exportRootPath${Platform.pathSeparator}$bookName";
    if (isOutChapter) {
      path += "${Platform.pathSeparator}$_exportChapterDirName";
    } else if (isOutBook) {
      path += "${Platform.pathSeparator}$_exportBookDirName";
    } else if (isOutZip) {
      path += "${Platform.pathSeparator}$_exportZipDirName";
    }
    return path;
  }
  
  /////////////////////////////////////////////////////////////////////////////
  //                                导出文件                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// 导出书本某一章节
  void exportChapter(String bookName, String chapterName) {
    File file = File("${_inputDirPath(bookName: bookName)}${Platform.pathSeparator}$chapterName");
    file.copySync("${_outputDirPath(bookName: bookName, isOutChapter: true)}${Platform.pathSeparator}$chapterName.txt");
  }

  /// 导出书本全部章节
  void exportBook(String bookName) {
    List<String> chapterList = _ioBase.getAllChapters(bookName);

    String inputPathPreFix = "${_inputDirPath(bookName: bookName)}${Platform.pathSeparator}";
    String outputPathPreFix = "${_outputDirPath(bookName: bookName, isOutBook: true)}${Platform.pathSeparator}";

    for (var index = 0; index < chapterList.length; ++index) {
      File file = File("$inputPathPreFix${chapterList[index]}");
      file.copySync("$outputPathPreFix$index${chapterList[index]}.txt");
    }
  }

  /// 导出.zip
  void exportZip(String bookName) {
    var encoder = ZipFileEncoder();
    encoder.create("${_outputDirPath(bookName: bookName)}${Platform.pathSeparator}$bookName.zip");
    encoder.addDirectory(Directory(_inputDirPath(bookName: bookName)));
    encoder.close();
  }

  void importBook(String bookName) {
    // Read the Zip file from disk.
    final bytes = File('test.zip').readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('out/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('out/' + filename).create(recursive: true);
      }
    }
  }
}