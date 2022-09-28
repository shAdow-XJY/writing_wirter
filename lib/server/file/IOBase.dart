import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  /// 判断是书：文件夹
  bool _isBook(Object object) {
    return (object.runtimeType.toString() == "_Directory");
  }
  bool _isChapter(Object object) {
    return (object.runtimeType.toString() == "_File");
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

  /////////////////////////////////////////////////////////////////////////////
  //                             查                                          //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历所有书名：遍历根文件夹
  List<String> getAllBooks() {
    List<String> bookNames = [];
    _rootDir.listSync().forEach((fileSystemEntity) {
      if(_isBook(fileSystemEntity)) {
        bookNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
      }
    });
    return bookNames;
  }

  /// 遍历书下所有章节：遍历书名文件夹
  List<String> getAllChapters(String bookName) {
    Directory dir = Directory(_rootPath + Platform.pathSeparator + bookName);
    List<String> chapterNames = [];
    dir.listSync().forEach((fileSystemEntity) {
      if(_isChapter(fileSystemEntity)) {
        chapterNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
      }
    });
    return chapterNames;
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