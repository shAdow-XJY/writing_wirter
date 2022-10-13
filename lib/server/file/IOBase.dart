import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

  /// 构造函数内部使用：初始化函数
  void _init() {
    _rootDir = Directory(_appDocPath + Platform.pathSeparator + _rootName);
    if(!_rootDir.existsSync()){
      _rootDir.create();
      // debugPrint(_rootDir.path);
    }
    _rootPath = _rootDir.path;
  }

  /// 判断是书/设定集：文件夹
  bool _isDir(Object object) {
    return (object.runtimeType.toString() == "_Directory");
  }

  /// 判断是章节/设定：文件夹
  bool _isFile(Object object) {
    return (object.runtimeType.toString() == "_File");
  }

  /// 根据路径打开资源管理器
  void _openFileManager(String path) {
    final Uri url = Uri.parse(path);
    launchUrl(url);
  }

  /////////////////////////////////////////////////////////////////////////////
  //                          额外可供访问函数                                  //
  ////////////////////////////////////////////////////////////////////////////
  void openRootDirectory() {
    _openFileManager(_rootPath);
  }

  void openBookDirectory(String bookName) {
    _openFileManager(_rootPath + Platform.pathSeparator + bookName);
  }

  void openSettingDirectory(String bookName) {
    _openFileManager("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集");
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                增                                       //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建一本书：文件夹
  void createBook(String bookName) {
    Directory dir = Directory(_rootPath + Platform.pathSeparator + bookName);
    if(!dir.existsSync()){
      dir.create();
      // debugPrint(dir.path);
      /// 创建该书对应设定集：文件夹
      Directory dir2 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集");
      if(!dir2.existsSync()){
        dir2.create();
      }
    }
  }

  /// 创建一章节：文件
  void createChapter(String bookName, String chapterName) {
    File file = File(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + chapterName);
    if(!file.existsSync()) {
      file.create();
      // debugPrint(file.path);
    }
  }

  /// 创建一个设定类：文件夹
  void createSetType(String bookName, String setTypeName) {
    Directory dir3 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setTypeName");
    if(!dir3.existsSync()) {
      dir3.create();
    }
  }

  /// 创建一个设定：文件
  void createSetting(String bookName, String setTypeName, String settingName) {
    Directory file2 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集${Platform.pathSeparator}$setTypeName${Platform.pathSeparator}$settingName");
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
    _rootDir.listSync().forEach((fileSystemEntity) {
      if(_isDir(fileSystemEntity)) {
        bookNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
      }
    });
    bookNames.sort();
    return bookNames;
  }

  /// 遍历书下所有章节：遍历书名文件夹
  List<String> getAllChapters(String bookName) {
    Directory dir = Directory(_rootPath + Platform.pathSeparator + bookName);
    List<String> chapterNames = [];
    dir.listSync().forEach((fileSystemEntity) {
      if(_isFile(fileSystemEntity)) {
        chapterNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
      }
    });
    chapterNames.sort();
    return chapterNames;
  }

  /// 遍历书对应设定集下所有设定：遍历书设定集设定名文件夹
  List<String> getAllSettings(String bookName) {
    Directory dir2 = Directory("$_rootPath${Platform.pathSeparator}$bookName${Platform.pathSeparator}$bookName设定集");
    List<String> settingNames = [];
    dir2.listSync().forEach((fileSystemEntity) {
      if(_isDir(fileSystemEntity)) {
        settingNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
      }
    });
    settingNames.sort();
    return settingNames;
  }

  /// 获取章节的文字内容：读取章节文件
  String getChapterContent(String bookName, String chapterName) {
    File file = File(_rootPath + Platform.pathSeparator + bookName + Platform.pathSeparator + chapterName);
    debugPrint(file.readAsStringSync());
    return file.readAsStringSync();
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             改                                          //
  ////////////////////////////////////////////////////////////////////////////

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

}