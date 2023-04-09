import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:writing_writer/service/file/file_configure.dart';
import 'dart:convert' as convert;
import '../../components/common/toast/global_toast.dart';
import '../config/BookConfig.dart';

class IOBase
{
  /// 电脑文档目录路径
  late final String _appDocPath;

  /// writing writer 写作根目录路径
  late final Directory _writeRootDir;
  
  IOBase() {
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

    /// 创建应用子文件夹：写作文件夹
    _writeRootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.writeRootDirPath()}");
    if (!_writeRootDir.existsSync()){
      _writeRootDir.createSync(recursive: true);
    }
  }

  /// 目录路径统一生成函数
  String _dirPath({String bookName = "", bool isChapterDir = false, bool isSetDir = false, String setName = ""}) {
    String path = _appDocPath;
    if (bookName.isNotEmpty) {
      /// ${bookName}/Chapter
      if (isChapterDir) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookChapterDirPath(bookName)}";
      }
      /// ${bookName}/Set
      else if (isSetDir && setName.isEmpty) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookSetRootDirPath(bookName)}";
      }
      /// ${bookName}/Set/${setName}
      else if (isSetDir && setName.isNotEmpty) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookSetDirPath(bookName, setName)}";
      }
      /// ${bookName}
      else {
        path += "${Platform.pathSeparator}${FileConfig.writeBookDirPath(bookName)}";
      }
    } else {
      path += "${Platform.pathSeparator}${FileConfig.rootDirPath()}";
    }
    return path;
  }

  /// 文件路径统一生成函数
  String _chsFilePath({String bookName = "", String chapterName = ""}) {
    String path = _appDocPath;
    if (bookName.isNotEmpty && chapterName.isNotEmpty) {
      path += "${Platform.pathSeparator}${FileConfig.writeBookChapterFilePath(bookName, chapterName)}";
    }
    return path;
  }

  /// json文件路径统一生成函数
  String _jsonFilePath({String bookName = "", bool isChapterJson = false, bool isSetJson = false, bool isSettingJson = false, String setName = "", String settingName = ""}) {
    String path = _appDocPath;
    if (bookName.isNotEmpty) {
      /// ${bookName}/Chapter.json
      if (isChapterJson) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookChapterJsonFilePath(bookName)}";
      }
      /// ${bookName}/Set/Set.json
      else if (isSetJson) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookSetJsonFilePath(bookName)}";
      }
      /// {$settingName}.json
      else if (isSettingJson || (setName.isNotEmpty && settingName.isNotEmpty)) {
        path += "${Platform.pathSeparator}${FileConfig.writeBookSettingJsonFilePath(bookName, setName, settingName)}";
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
    _openFileManager(_dirPath(bookName: bookName, isChapterDir: true));
  }

  void openSettingDirectory(String bookName) {
    _openFileManager(_dirPath(bookName: bookName, isSetDir: true));
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             书籍                                        //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历所有书名：遍历根文件夹
  List<String> getAllBooks() {
    List<String> bookNames = [];
    try {
      _writeRootDir.listSync().forEach((fileSystemEntity) {
        if (_isDir(fileSystemEntity)) {
          bookNames.add(fileSystemEntity.path.split(Platform.pathSeparator).last);
          // debugPrint(fileSystemEntity.path.split(Platform.pathSeparator).last);
        }
      });
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取书籍失败',);
      print(s);
    }
    bookNames.sort();
    return bookNames;
  }

  /// 创建一本书：文件夹
  void createBook(String bookName) {
    try {
      Directory dir = Directory(_dirPath(bookName: bookName));
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
        /// 创建书对应Chapter：文件夹
        createBookNameChapterDir(bookName);
        /// 创建该书对应Set：文件夹
        createBookNameSetDir(bookName);
      }
      GlobalToast.showSuccessTop('创建书籍成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建书籍失败',);
      print(s);
    }
  }

  /// 书籍重命名
  void renameBook(String oldBookName, String newBookName) {
    try {
      Directory dir = Directory(_dirPath(bookName: oldBookName));
      if (dir.existsSync()) {
        dir.renameSync(_dirPath(bookName: newBookName));
        /// Chapter.json操作：书籍重命名
        renameBookInChapterJson(newBookName);
        /// Set.json操作：书籍重命名
        renameBookInSetJson(newBookName);
      }
      GlobalToast.showSuccessTop('重命名书籍成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名书籍失败',);
      print(s);
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             章节                                        //
  ////////////////////////////////////////////////////////////////////////////
  /// 创建书对应Chapter：文件夹
  void createBookNameChapterDir(String bookName) {
    Directory dir2 = Directory(_dirPath(bookName: bookName, isChapterDir: true));
    if (!dir2.existsSync()) {
      dir2.createSync(recursive: true);
    }
    /// 创建该书对应Chapter.json：json文件
    createBookChapterJson(bookName);
  }

  /// 遍历指定书下所有章节：读取对应书籍-章节文件：Chapter.json
  List<String> getAllChapters(String bookName) {
    List<String> chapterNames = [];
    if (bookName.isEmpty) {
      return chapterNames;
    }
    try {
      if (getBookChapterJsonContent(bookName)["chapterList"] != null) {
        chapterNames = getBookChapterJsonContent(bookName)["chapterList"].cast<String>();
      }
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取书籍章节失败',);
      print(s);
    }
    return chapterNames;
  }

  /// 创建一章节：文件
  void createChapter(String bookName, String chapterName) {
    try {
      File file = File(_chsFilePath(bookName: bookName, chapterName: chapterName));
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      addNewChapterInChapterJson(bookName, chapterName);
      GlobalToast.showSuccessTop('创建章节成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建章节失败',);
      print(s);
    }
  }

  /// 章节重命名
  void renameChapter(String bookName, String oldChapterName, String newChapterName) {
    try {
      File file = File(_chsFilePath(bookName: bookName, chapterName: oldChapterName));
      if (file.existsSync()) {
        file.renameSync(_chsFilePath(bookName: bookName, chapterName: newChapterName));
      }
      /// chapter.json 章节重命名
      renameChapterInChapterJson(bookName, oldChapterName, newChapterName);
      GlobalToast.showSuccessTop('重命名章节成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名章节失败',);
      print(s);
    }
  }

  /// 保存章节
  void saveChapter(String bookName, String chapterName, String content) {
    File file = File(_chsFilePath(bookName: bookName, chapterName: chapterName));
    if (file.existsSync()) {
      file.writeAsStringSync(content);
    }
  }

  /// 获取章节的文字内容：读取章节文件
  String getChapterContent(String bookName, String chapterName) {
    File file = File(_chsFilePath(bookName: bookName, chapterName: chapterName));
    String content = "";
    try {
      content = file.readAsStringSync();
      // debugPrint(file.readAsStringSync());
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取章节文字内容失败',);
      print(s);
    }
    return content;
  }

  /////////////////////////////////////////////////////////////////////////////
  //                             设定集                                       //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建书对应Set：文件夹
  void createBookNameSetDir(String bookName) {
    Directory dir2 = Directory(_dirPath(bookName: bookName, isSetDir: true));
    if (!dir2.existsSync()) {
      dir2.createSync(recursive: true);
    }
    /// 创建书对应Set.json：json文件
    createBookSetJson(bookName);
  }

  /// 遍历书下所有设定集：该书对应Set.json：json文件
  Map<String, dynamic> getAllSetMap(String bookName) {
    Map<String, dynamic> bookSetJson = {};
    if (bookName.isEmpty) {
      return bookSetJson;
    }
    try {
      bookSetJson = getBookSetJsonContent(bookName);
    } on Exception catch (e, s) {
      debugPrint("/// 遍历书下所有设定集：该书对应Set.json：json文件");
      GlobalToast.showErrorTop('获取书籍设定集失败',);
      print(s);
    }
    return bookSetJson;
  }

  /// 创建一个设定集：文件夹
  void createSet(String bookName, String setName) {
    try {
      Directory dir2 = Directory(_dirPath(bookName: bookName, isSetDir: true, setName: setName));
      if (!dir2.existsSync()) {
        dir2.createSync(recursive: true);
      }
      /// Set.json添加（新建设定类）
      addNewSetInSetJson(bookName, setName);
      GlobalToast.showSuccessTop('创建设定集成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建设定集失败',);
      print(s);
    }
  }

  /// 设定集(文件夹)重命名
  void renameSet(String bookName, String oldSetName, String newSetName) {
    try {
      Directory dir = Directory(_dirPath(bookName: bookName, isSetDir: true, setName: oldSetName));
      if (dir.existsSync()) {
        dir.renameSync(_dirPath(bookName: bookName, isSetDir: true, setName: newSetName));
      }
      /// Set.json操作：设定集重命名
      renameSetInSetJson(bookName, oldSetName, newSetName);
      GlobalToast.showSuccessTop('重命名设定集成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名设定集失败',);
      print(s);
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                      设定 {$settingName}.json                           //
  ////////////////////////////////////////////////////////////////////////////

  /// 遍历指定设定集下所有设定：遍历设定（.json文件）
  List<String> getAllSettings(String bookName, String setName) {
    List<String> settingNames = [];
    if (bookName.isEmpty || setName.isEmpty) {
      return settingNames;
    }
    try {
      if (getBookSetJsonContent(bookName)[setName]["settingList"] != null) {
        settingNames = getBookSetJsonContent(bookName)[setName]["settingList"].cast<String>();
      }
    } on Exception catch (e, s) {
      debugPrint("/// 遍历指定设定集下所有设定：遍历设定（.json文件）");
      GlobalToast.showErrorTop('获取设定集的设定失败',);
      print(s);
    }
    return settingNames;
  }

  /// 创建设定集内一个设定：json文件
  void createSetting(String bookName, String setName, String settingName) {
    try {
      File file2 = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
      if (!file2.existsSync()) {
        file2.createSync(recursive: true);
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
      /// Set.json添加设定（新建设定）
      addNewSettingInSetJson(bookName, setName, settingName);
      GlobalToast.showSuccessTop('创建设定成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建设定失败',);
      print(s);
    }
  }

  /// 保存设定(json文件)
  void saveSetting(String bookName, String setName, String settingName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
  }

  /// 设定(json文件)重命名
  void renameSetting(String bookName, String setName, String oldSettingName, String newSettingName) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: oldSettingName));
      if (file.existsSync()) {
        file.renameSync(_jsonFilePath(bookName: bookName, setName: setName, settingName: newSettingName));
      }
      GlobalToast.showSuccessTop('重命名设定成功',);
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名设定失败',);
      print(s);
    }
  }

  /// 设定(json文件)操作： 设定Set重命名
  void renameSetInSetting(String bookName, String newSetName, String settingName) {
    Map<String, dynamic> settingJson = getSettingJson(bookName, newSetName, settingName);
    settingJson.update("setName", (value) => newSetName);
    saveSetting(bookName, newSetName, settingName, convert.jsonEncode(settingJson));
  }

  /// 获取设定的内容：读取设定json文件内容
  Map<String, dynamic> getSettingJson(String bookName, String setName, String settingName) {
    File file2 = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
    String bookSettingContent = "";
    try {
      bookSettingContent = file2.readAsStringSync();
      debugPrint(file2.readAsStringSync());
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取设定的内容失败',);
      print(s);
    }
    return convert.jsonDecode(bookSettingContent);
  }

  /////////////////////////////////////////////////////////////////////////////
  //                (书籍-章节)Chapter.json                                   //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建该书对应Chapter.json：json文件
  void createBookChapterJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    if (!file2.existsSync()) {
      file2.createSync(recursive: true);
    }
    saveBookChapterJson(bookName, BookConfig.getDefaultBookChapterJsonString(bookName: bookName));
  }

  /// Chapter.json读取
  Map<String, dynamic> getBookChapterJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    String jsonContent = "";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("/// Chapter.json读取");
      print(s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// Chapter.json保存（初始化、章节顺序有变化）
  void saveBookChapterJson(String bookName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
  }

  /// Chapter.json操作：添加新建章节
  void addNewChapterInChapterJson(String bookName, String chapterName) {
    Map<String, dynamic> bookChapterJson = getBookChapterJsonContent(bookName);
    bookChapterJson["chapterList"].add(chapterName);
    saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }
  
  /// Chapter.json操作：书籍重命名
  void renameBookInChapterJson(String bookName) {
    Map<String, dynamic> bookChapterJson = getBookChapterJsonContent(bookName);
    bookChapterJson["bookName"] = bookName;
    saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }

  /// Chapter.json操作：章节重命名
  void renameChapterInChapterJson(String bookName, String oldChapterName, String newChapterName) {
    Map<String, dynamic> bookChapterJson = getBookChapterJsonContent(bookName);
    int index = bookChapterJson["chapterList"].indexOf(oldChapterName);
    bookChapterJson["chapterList"][index] = newChapterName;
    saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }
  /////////////////////////////////////////////////////////////////////////////
  //                     (书籍-设定)Set.json                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// 创建该书对应Set.json：json文件
  void createBookSetJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isSetJson: true));
    if (!file2.existsSync()) {
      file2.createSync(recursive: true);
    }
    saveBookSetJson(bookName, BookConfig.getDefaultBookSetJsonString(bookName: bookName));
  }

  /// Set.json读取
  Map<String, dynamic> getBookSetJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isSetJson: true));
    String jsonContent = "";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("Set.json读取");
      print(s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// Set.json保存
  void saveBookSetJson(String bookName, String content) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, isSetJson: true));
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      file.writeAsStringSync(content);
    } on Exception catch (e, s) {
      debugPrint("/// Set.json保存");
      print(s);
    }
  }

  /// Set.json操作：书籍重命名
  void renameBookInSetJson(String bookName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    bookSetJson["bookName"] = bookName;
    /// 保存
    saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：添加新建设定类
  void addNewSetInSetJson(String bookName, String setName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    /// setList: ["${setName}"]
    Map<String, dynamic> newSetMap = {};
    newSetMap["setName"] = setName;
    newSetMap["isParsed"] = true;
    bookSetJson["setList"].add(newSetMap);
    /// ${setName}: {}
    bookSetJson[setName] = {"settingList": []};
    /// 保存
    saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：添加新建设定
  void addNewSettingInSetJson(String bookName, String setName, String settingName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    Map<String, dynamic> newSetSettingMap = bookSetJson[setName];
    newSetSettingMap["settingList"].add(settingName);
    /// 保存
    saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：设定集重命名
  void renameSetInSetJson(String bookName, String oldSetName, String newSetName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    List<dynamic> settingList = bookSetJson["setList"];
    for (var setObj in settingList) {
      if (setObj["setName"].toString().compareTo(oldSetName) == 0) {
        setObj["setName"] = newSetName;
        break;
      }
    }
    bookSetJson[newSetName] = bookSetJson.remove(oldSetName);
    /// 保存
    saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
    /// set下所有${settingName}.json 的 setName 属性也修改
    List<String> allSettings = getAllSettings(bookName, newSetName);
    for (String settingName in allSettings) {
      renameSetInSetting(bookName, newSetName, settingName);
    }
  }

  /// Set.json操作：修改属性值isParsed（是否加入解析）
  void changeParserOfBookSetJson(String bookName, String setName, bool isParsed) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    List<dynamic> settingList = bookSetJson["setList"];
    for (var setObj in settingList) {
      if (setObj["setName"].toString().compareTo(setName) == 0) {
        setObj["isParsed"] = isParsed;
        break;
      }
    }
    /// 保存
    saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }
}