import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert' as convert;
import '../config/BookConfig.dart';

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
    if (!_rootDir.existsSync()){
      /// 创建应用文件夹
      _rootDir.create();
      // debugPrint(_rootDir.path);
    }
    _rootPath = _rootDir.path;
  }

  /// 目录路径统一生成函数
  String _dirPath({String bookName = "", bool isSet = false, String setName = ""}) {
    String path = _rootPath;
    if (bookName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName";
      if (isSet) {
        path += "${Platform.pathSeparator}${bookName}Set";
        if (setName.isNotEmpty) {
          path += "${Platform.pathSeparator}$setName";
        }
      }
    }
    return path;
  }

  /// 文件路径统一生成函数
  String _filePath({String bookName = "", String chapterName = ""}) {
    String path = _rootPath;
    if (bookName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName";
      if (chapterName.isNotEmpty) {
        path += "${Platform.pathSeparator}$chapterName";
      }
    }
    return path;
  }

  /// json文件路径统一生成函数
  String _jsonFilePath({String bookName = "", bool isBookChapterJson = false, bool isBookSetJson = false, bool isSetSettingJson = false, String setName = "", String settingName = ""}) {
    String path = _rootPath;
    if (bookName.isNotEmpty) {
      path += "${Platform.pathSeparator}$bookName";
      /// {$bookName}Chapter.json
      if (isBookChapterJson) {
        path += "${Platform.pathSeparator}${bookName}Chapter.json";
      }
      /// {$bookName}Set.json
      else if (isBookSetJson) {
        path += "${Platform.pathSeparator}${bookName}Set";
        path += "${Platform.pathSeparator}${bookName}Set.json";
      }
      /// {$settingName}.json
      else if (isSetSettingJson || (setName.isNotEmpty && settingName.isNotEmpty)) {
        path += "${Platform.pathSeparator}${bookName}Set";
        path += "${Platform.pathSeparator}$setName";
        path += "${Platform.pathSeparator}$settingName.json";
      }
    }
    return path;
  }

  /// 判断是书/设定集：文件夹
  bool _isDir(Object object) {
    return (object.runtimeType.toString() == "_Directory");
  }

  /// 判断是章节/设定：文件
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
  //                             书籍                                        //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历所有书名：遍历根文件夹
  List<String> getAllBooks() {
    List<String> bookNames = [];
    try {
      _rootDir.listSync().forEach((fileSystemEntity) {
        if (_isDir(fileSystemEntity)) {
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

  /// 创建一本书：文件夹
  void createBook(String bookName) {
    Directory dir = Directory(_dirPath(bookName: bookName));
    if (!dir.existsSync()) {
      dir.create();
      /// 创建该书对应{$bookName}Set：文件夹
      createBookNameSetDir(bookName);
      /// 创建该书对应{$bookName}Chapter.json：json文件
      createBookChapterJson(bookName);
    }
  }

  /// 书籍重命名
  void renameBook(String oldBookName, String newBookName) {
    try {
      Directory dir = Directory(_dirPath(bookName: oldBookName));
      if (dir.existsSync()) {
        dir.renameSync(_dirPath(bookName: newBookName));
        /// 再重命名该书对应{$bookName}Set：文件夹
        renameBookNameSetDir(oldBookName, newBookName);
        /// 再重命名该书对应{$bookName}Chapter.json：json文件
        renameBookChapterJson(oldBookName, newBookName);
      }
    } on Exception catch (e, s) {
      debugPrint("/// 书籍重命名");
      print(s);
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             章节                                        //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历指定书下所有章节：读取对应书籍-章节json文件
  List<String> getAllChapters(String bookName) {
    List<String> chapterNames = [];
    if (bookName.isEmpty) {
      return chapterNames;
    }
    try {
      chapterNames = getBookChapterJsonContent(bookName)["chapterList"].cast<String>() ?? [];
    } on Exception catch (e, s) {
      debugPrint("/// 遍历指定书下所有章节：读取对应书籍-章节json文件");
      print(s);
    }
    return chapterNames;
  }

  /// 创建一章节：文件
  void createChapter(String bookName, String chapterName) {
    File file = File(_filePath(bookName: bookName, chapterName: chapterName));
    if (!file.existsSync()) {
      file.create();
    }
    addBookChapterJson(bookName, chapterName);
  }

  /// 章节重命名
  void renameChapter(String bookName, String oldChapterName, String newChapterName) {
    File file = File(_filePath(bookName: bookName, chapterName: oldChapterName));
    if (file.existsSync()) {
      file.renameSync(_filePath(bookName: bookName, chapterName: newChapterName));
    }
  }

  /// 保存章节
  void saveChapter(String bookName, String chapterName, String content) {
    File file = File(_filePath(bookName: bookName, chapterName: chapterName));
    if (file.existsSync()) {
      file.writeAsStringSync(content);
    }
  }

  /// 获取章节的文字内容：读取章节文件
  String getChapterContent(String bookName, String chapterName) {
    File file = File(_filePath(bookName: bookName, chapterName: chapterName));
    String content = "";
    try {
      content = file.readAsStringSync();
      // debugPrint(file.readAsStringSync());
    } on Exception catch (e, s) {
      print(s);
    }
    return content;
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             设定集                                       //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建书对应{$bookName}Set：文件夹
  void createBookNameSetDir(String bookName) {
    Directory dir2 = Directory(_dirPath(bookName: bookName, isSet: true));
    if (!dir2.existsSync()) {
      dir2.create(recursive: true);
    }
    /// 创建书对应{$bookName}Set.json：json文件
    createBookSetJson(bookName);
  }

  /// 重命名书对应{$bookName}Set：文件夹
  void renameBookNameSetDir(String oldBookName, String newBookName) {
    File file2 = File("$_rootPath${Platform.pathSeparator}$newBookName${Platform.pathSeparator}${oldBookName}Chapter.json");
    if (file2.existsSync()) {
      file2.renameSync(_dirPath(bookName: newBookName, isSet: true));
    }
  }

  /// 遍历书下所有设定集：遍历该书对应{$bookName}Set：文件夹
  List<String> getAllSet(String bookName) {
    List<String> settingNames = [];
    if (bookName.isEmpty) {
      return settingNames;
    }
    Directory setDir = Directory(_dirPath(bookName: bookName, isSet: true));
    try {
      setDir.listSync().forEach((fileSystemEntity) {
        if (_isDir(fileSystemEntity)) {
          settingNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      debugPrint("/// 遍历书下所有设定集：遍历设定集文件夹名称");
      print(s);
    }
    settingNames.sort();
    return settingNames;
  }

  /// 创建一个设定集：文件夹
  void createSet(String bookName, String setName) {
    Directory dir2 = Directory(_dirPath(bookName: bookName, isSet: true, setName: setName));
    if (!dir2.existsSync()) {
      dir2.create();
    }
  }

  /// 设定集(文件夹)重命名
  void renameSet(String bookName, String oldSetName, String newSetName) {
    Directory dir = Directory(_dirPath(bookName: bookName, isSet: true, setName: oldSetName));
    if (dir.existsSync()) {
      dir.renameSync(_dirPath(bookName: bookName, isSet: true, setName: newSetName));
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                              设定                                        //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历指定设定集下所有设定：遍历设定（.json文件）
  List<String> getAllSettings(String bookName, String setName) {
    List<String> settingNames = [];
    if (bookName.isEmpty || setName.isEmpty) {
      return settingNames;
    }
    Directory setDir2 = Directory(_dirPath(bookName: bookName, isSet: true, setName: setName));
    try {
      setDir2.listSync().forEach((fileSystemEntity) {
        if (_isFile(fileSystemEntity)) {
          settingNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last.split('.').first);
        }
      });
    } on Exception catch (e, s) {
      debugPrint("/// 遍历指定设定集下所有设定：遍历设定（.json文件）");
      print(s);
    }
    settingNames.sort();
    return settingNames;
  }

  /// 创建设定集内一个设定：json文件
  void createSetting(String bookName, String setName, String settingName) {
    File file2 = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
    if (!file2.existsSync()) {
      file2.create();
    }
    saveSetting(
        bookName,
        setName,
        settingName,
        BookConfig.getDefaultSetSettingJsonString(
          bookName: bookName,
          setName: setName,
          settingName: settingName
        )
    );
  }

  /// 保存设定(json文件)
  void saveSetting(String bookName, String setName, String settingName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
    if (!file.existsSync()) {
      file.create();
    }
    file.writeAsStringSync(content);
  }

  /// 设定(json文件)重命名
  void renameSetting(String bookName, String setName, String oldSettingName, String newSettingName) {
    File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: oldSettingName));
    if (file.existsSync()) {
      file.renameSync(_jsonFilePath(bookName: bookName, setName: setName, settingName: newSettingName));
    }
  }

  /// 获取设定的内容：读取设定json文件内容
  String getSettingContent(String bookName, String setName, String settingName) {
    File file2 = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
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
  //                (书籍-章节){$bookName}Chapter.json                        //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建该书对应{$bookName}Chapter.json：json文件
  void createBookChapterJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isBookChapterJson: true));
    if (!file2.existsSync()) {
      file2.create();
    }
    saveBookChapterJson(bookName, BookConfig.getDefaultBookChapterJsonString(bookName: bookName));
  }

  /// 重命名该书对应{$bookName}Chapter.json：json文件
  void renameBookChapterJson(String oldBookName, String newBookName) {
    File file2 = File("$_rootPath${Platform.pathSeparator}$newBookName${Platform.pathSeparator}${oldBookName}Chapter.json");
    if (file2.existsSync()) {
      file2.renameSync(_jsonFilePath(bookName: newBookName, isBookChapterJson: true));
    }
  }

  /// {$bookName}Chapter.json读取
  Map<String, dynamic> getBookChapterJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isBookChapterJson: true));
    String jsonContent = "";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("/// bookJson读取");
      print(s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// {$bookName}Chapter.json保存（初始化、章节顺序有变化）
  void saveBookChapterJson(String bookName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, isBookChapterJson: true));
    if (!file.existsSync()) {
      file.create();
    }
    file.writeAsStringSync(content);
  }

  /// {$bookName}Chapter.json添加（新建章节）
  void addBookChapterJson(String bookName, String chapterName) {
    Map<String, dynamic> bookJson =  getBookChapterJsonContent(bookName);
    bookJson["chapterList"].add(chapterName);
    saveBookChapterJson(bookName, convert.jsonEncode(bookJson));
  }

  /////////////////////////////////////////////////////////////////////////////
  //                     (书籍-设定){$bookName}Set.json                       //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建该书对应{$bookName}Set.json：json文件
  void createBookSetJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isBookSetJson: true));
    if (!file2.existsSync()) {
      file2.create();
    }
  }

  /// 重命名该书对应{$bookName}Set.json：json文件
  void renameBookSetJson(String oldBookName, String newBookName) {
    File file2 = File("$_rootPath${Platform.pathSeparator}$newBookName${Platform.pathSeparator}${oldBookName}Set.json");
    if (file2.existsSync()) {
      file2.renameSync(_jsonFilePath(bookName: newBookName, isBookSetJson: true));
    }
  }

  /// {$bookName}Set.json读取
  Map<String, dynamic> getBookSetJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isBookSetJson: true));
    String jsonContent = "";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("{$bookName}Set.json读取");
      print(s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// {$bookName}Set.json保存（初始化、章节顺序有变化）
  void saveBookSetJson(String bookName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, isBookSetJson: true));
    if (!file.existsSync()) {
      file.create();
    }
    file.writeAsStringSync(content);
  }

  /// {$bookName}Set.json添加（新建章节）
  void addBookSetJson(String bookName, String chapterName) {
    Map<String, dynamic> bookJson =  getBookChapterJsonContent(bookName);
    bookJson["chapterList"].add(chapterName);
    saveBookChapterJson(bookName, convert.jsonEncode(bookJson));
  }
}