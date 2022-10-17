import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IOBase
{
  /// 电脑文档目录路径
  late final Directory _appDocDir;
  late final String _appDocPath;

  /// writing writer 根目录路径
  late final Directory _rootDir;
  late final String _rootPath;
  final String _rootName = "wWriter";

  IOBase() {
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
    _rootDir = Directory(_appDocPath + Platform.pathSeparator + _rootName);
    if(!_rootDir.existsSync()){
      _rootDir.create();
      // debugPrint(_rootDir.path);
    }
    _rootPath = _rootDir.path;
  }

  /// 目录路径统一生成函数
  String _dirPath({String bookName = "", bool isSet = false, String setName = ""}) {
    String path = _rootPath;
    if(bookName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName";
      if(isSet) {
        path += "${Platform.pathSeparator}$bookName设定集";
        if(setName.isNotEmpty) {
          path += "${Platform.pathSeparator}$setName";
        }
      }
    }
    return path;
  }

  /// 文件路径统一生成函数
  String _filePath({String bookName = "", String chapterName = "", String setName = "", String settingName = ""}) {
    String path = _rootPath;
    if(bookName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName";
      if(chapterName.isNotEmpty) {
        path += "${Platform.pathSeparator}$chapterName";
      }
    }
    if(setName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName设定集";
      path += "${Platform.pathSeparator}$setName";
      if(settingName.isNotEmpty) {
        path += "${Platform.pathSeparator}$settingName";
      }
    }
    return path;
  }

  /// 判断是书/一级设定：文件夹
  bool _isDir(Object object) {
    return (object.runtimeType.toString() == "_Directory");
  }

  /// 判断是章节/二级设定：文件夹
  bool _isFile(Object object) {
    return (object.runtimeType.toString() == "_File");
  }

  /// 根据路径打开资源管理器
  void _openFileManager(String path) {
    final Uri url = Uri.file(path);
    /// launchUrl(url);
    /// 改用下面的方法解决路径中包含中文导致打开失败
    launchUrlString(url.toFilePath());
  }

  /////////////////////////////////////////////////////////////////////////////
  //                          额外可供访问函数                                  //
  ////////////////////////////////////////////////////////////////////////////
  void openRootDirectory() {
    _openFileManager(_dirPath());
  }

  void openBookDirectory(String bookName) {
    _openFileManager(_dirPath(bookName: bookName));
  }

  void openSettingDirectory(String bookName) {
    _openFileManager(_dirPath(bookName: bookName, isSet: true));
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                增                                       //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建一本书：文件夹
  void createBook(String bookName) {
    Directory dir = Directory(_dirPath(bookName: bookName));
    if(!dir.existsSync()){
      dir.create();
      // debugPrint(dir.path);
      /// 创建该书对应设定集：文件夹
      Directory dir2 = Directory(_dirPath(bookName: bookName, isSet: true));
      if(!dir2.existsSync()){
        dir2.create();
      }
    }
  }

  /// 创建一章节：文件
  void createChapter(String bookName, String chapterName) {
    File file = File(_filePath(bookName: bookName, chapterName: chapterName));
    if(!file.existsSync()) {
      file.create();
      // debugPrint(file.path);
    }
  }

  /// 创建一个一级设定：文件夹
  void createSet(String bookName, String setName) {
    Directory dir3 = Directory(_dirPath(bookName: bookName, isSet: true, setName: setName));
    if(!dir3.existsSync()) {
      dir3.create();
    }
  }

  /// 创建一级设定内一个二级设定：文件
  void createSetting(String bookName, String setName, String settingName) {
    File file2 = File(_filePath(bookName: bookName, setName: setName, settingName: settingName));
    if(!file2.existsSync()) {
      file2.create();
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             查                                          //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历所有书名：遍历根文件夹
  List<String> getAllBooks() {
    List<String> bookNames = [];
    try {
      _rootDir.listSync().forEach((fileSystemEntity) {
        if(_isDir(fileSystemEntity)) {
          bookNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
          // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      print(s);
    }
    bookNames.sort();
    return bookNames;
  }

  /// 遍历指定书下所有章节：遍历书名文件夹
  List<String> getAllChapters(String bookName) {
    Directory dir = Directory(_rootPath + Platform.pathSeparator + bookName);
    List<String> chapterNames = [];
    try {
      dir.listSync().forEach((fileSystemEntity) {
        if(_isFile(fileSystemEntity)) {
          chapterNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
          // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      print(s);
    }
    chapterNames.sort();
    return chapterNames;
  }

  /// 遍历书下所有一级设定：遍历一级设定名文件夹
  List<String> getAllSet(String bookName) {
    Directory dir2 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集");
    List<String> settingNames = [];
    try {
      dir2.listSync().forEach((fileSystemEntity) {
        if(_isDir(fileSystemEntity)) {
          settingNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
          // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      print(s);
    }
    settingNames.sort();
    return settingNames;
  }

  /// 遍历指定一级设定下所有二级设定：遍历二级设定名文件
  List<String> getAllSettings(String bookName, String setName) {
    Directory dir3 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setName");
    List<String> settingNames = [];
    try {
      dir3.listSync().forEach((fileSystemEntity) {
        if(_isFile(fileSystemEntity)) {
          settingNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      print(s);
    }
    settingNames.sort();
    return settingNames;
  }

  /// 获取章节的文字内容：读取章节文件
  String getChapterContent(String bookName, String chapterName) {
    File file = File(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + chapterName);
    String content = "";
    try {
      content = file.readAsStringSync();
      debugPrint(file.readAsStringSync());
    } on Exception catch (e, s) {
      print(s);
    }
    return content;
  }

  /// 获取二级设定的内容：读取二级设定文件
  String getSettingContent(String bookName, String setName, String settingName) {
    File file2 = File("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setName${Platform.pathSeparator}$settingName");
    String content = "";
    try {
      content = file2.readAsStringSync();
      debugPrint(file2.readAsStringSync());
    } on Exception catch (e, s) {
      print(s);
    }
    return content;
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             改                                          //
  ////////////////////////////////////////////////////////////////////////////

  /// 书籍重命名
  void renameBook(String oldBookName, String newBookName) {
    Directory dir = Directory(_dirPath(bookName: oldBookName));
    if(dir.existsSync()) {
      dir.renameSync(_dirPath(bookName: newBookName));
      /// 再重命名该书对应设定集：文件夹
      Directory dir2 = Directory("$_rootPath${Platform.pathSeparator}$newBookName${Platform.pathSeparator}$oldBookName设定集");
      if(dir2.existsSync()){
        dir2.renameSync(_dirPath(bookName: newBookName, isSet: true));
      }
    }
  }

  /// 保存章节
  void saveChapter(String bookName, String chapterName, String content) {
    File file = File(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + chapterName);
    if(file.existsSync()) {
      file.writeAsStringSync(content);
    }
  }

  /// 章节重命名
  void renameChapter(String bookName, String oldChapterName, String newChapterName) {
    File file = File(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + oldChapterName);
    if(file.existsSync()) {
      file.renameSync(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + newChapterName);
    }
  }

  /// 一级设定重命名
  void renameSet(String bookName, String oldSetName, String newSetName) {
    Directory dir = Directory(_dirPath(bookName: bookName, isSet: true, setName: oldSetName));
    if(dir.existsSync()) {
      dir.renameSync(_dirPath(bookName: bookName, isSet: true, setName: newSetName));
    }
  }

  /// 保存二级设定
  void saveSetting(String bookName, String setName, String settingName, String content) {
    File file = File("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setName${Platform.pathSeparator}$settingName");
    if(file.existsSync()) {
      file.writeAsStringSync(content);
    }
  }

  /// 二级设定重命名
  void renameSetting(String bookName, String setName, String oldSettingName, String newSettingName) {
    File file = File("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setName${Platform.pathSeparator}$oldSettingName");
    if(file.existsSync()) {
      file.renameSync("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setName${Platform.pathSeparator}$newSettingName");
    }
  }
}