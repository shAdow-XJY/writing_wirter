// ignore_for_file: file_names

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

  /// 章节文件路径统一生成函数
  String _chsFilePath({String bookName = "", String chapterName = ""}) {
    String path = _appDocPath;
    if (bookName.isNotEmpty && chapterName.isNotEmpty) {
      path += "${Platform.pathSeparator}${FileConfig.writeBookChapterFilePath(bookName, chapterName)}";
    }
    return path;
  }

  /// Setting.sort文件路径统一生成函数
  String _sortFilePath({String bookName = "", String setName = ""}) {
    String path = _appDocPath;
    if (bookName.isNotEmpty && setName.isNotEmpty) {
      path += "${Platform.pathSeparator}${FileConfig.writeBookSettingSortFilePath(bookName, setName)}";
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
      GlobalToast.showErrorTop('获取书籍失败');
      debugPrintStack(stackTrace: s);
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
      GlobalToast.showSuccessTop('创建书籍成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建书籍失败');
      debugPrintStack(stackTrace: s);
    }
  }
  
  /// 书籍删除
  void removeBook(String bookName) {
    try {
      Directory dir = Directory(_dirPath(bookName: bookName));
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      GlobalToast.showSuccessTop('删除书籍成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('删除书籍失败');
      debugPrintStack(stackTrace: s);
    }
  }
  
  /// 书籍重命名
  void renameBook(String oldBookName, String newBookName) {
    try {
      Directory dir = Directory(_dirPath(bookName: oldBookName));
      if (dir.existsSync()) {
        dir.renameSync(_dirPath(bookName: newBookName));
      }
      GlobalToast.showSuccessTop('重命名书籍成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名书籍失败');
      debugPrintStack(stackTrace: s);
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
    _createBookChapterJson(bookName);
  }

  /// 遍历指定书下所有章节：读取对应书籍-章节文件：Chapter.json
  List<String> getAllChapters(String bookName) {
    List<String> chapterNames = [];
    if (bookName.isEmpty) {
      return chapterNames;
    }
    try {
      if (_getBookChapterJsonContent(bookName)["chapterList"] != null) {
        chapterNames = _getBookChapterJsonContent(bookName)["chapterList"].cast<String>();
      }
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取书籍章节失败');
      debugPrintStack(stackTrace: s);
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
      _addNewChapterInChapterJson(bookName, chapterName);
      GlobalToast.showSuccessTop('创建章节成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建章节失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /// 删除一章节：文件
  void removeChapter(String bookName, String chapterName) {
    try {
      File file = File(_chsFilePath(bookName: bookName, chapterName: chapterName));
      if (file.existsSync()) {
        file.deleteSync(recursive: true);
      }
      _removeChapterInChapterJson(bookName, chapterName);
      GlobalToast.showSuccessTop('删除章节成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('删除章节失败');
      debugPrintStack(stackTrace: s);
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
      _renameChapterInChapterJson(bookName, oldChapterName, newChapterName);
      GlobalToast.showSuccessTop('重命名章节成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名章节失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /// 保存章节
  void saveChapter(String bookName, String chapterName, String content) {
    try {
      File file = File(_chsFilePath(bookName: bookName, chapterName: chapterName));
      if (file.existsSync()) {
        file.writeAsStringSync(content);
      }
      GlobalToast.showSuccessTop('保存章节文字内容成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('保存章节文字内容失败');
      debugPrintStack(stackTrace: s);
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
      GlobalToast.showErrorTop('获取章节文字内容失败');
      debugPrintStack(stackTrace: s);
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
    _createBookSetJson(bookName);
  }

  /// 遍历书下所有设定集：该书对应Set.json：json文件
  List<String> getAllSets(String bookName) {
    List<String> setList = [];
    if (bookName.isEmpty) {
      return setList;
    }
    try {
      setList = getBookSetJsonContent(bookName)["setList"].cast<String>();
    } on Exception catch (e, s) {
      debugPrint("/// 遍历书下所有设定集：该书对应Set.json：json文件");
      GlobalToast.showErrorTop('获取书籍设定集失败');
      debugPrintStack(stackTrace: s);
    }
    return setList;
  }
  
  /// 创建一个设定集：文件夹
  void createSet(String bookName, String setName) {
    try {
      Directory dir2 = Directory(_dirPath(bookName: bookName, isSetDir: true, setName: setName));
      if (!dir2.existsSync()) {
        dir2.createSync(recursive: true);
      }
      /// 文件夹下初始化Setting.sort
      _createSettingSort(bookName, setName);
      /// Set.json添加（新建设定类）
      _addNewSetInSetJson(bookName, setName);
      GlobalToast.showSuccessTop('创建设定集成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建设定集失败');
      debugPrintStack(stackTrace: s);
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
      _renameSetInSetJson(bookName, oldSetName, newSetName);
      GlobalToast.showSuccessTop('重命名设定集成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名设定集失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /// 设定集(文件夹)删除
  void removeSet(String bookName, String setName) {
    try {
      Directory dir = Directory(_dirPath(bookName: bookName, isSetDir: true, setName: setName));
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      /// Set.json操作：设定集重命名
      _removeSetInSetJson(bookName, setName);
      GlobalToast.showSuccessTop('删除设定集成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('删除设定集失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                      设定 {$settingName}.json                           //
  ////////////////////////////////////////////////////////////////////////////

  /// 获取指定设定集下所有设定：从Setting.sort获取设定List（.json文件）
  List<String> getAllSettings(String bookName, String setName) {
    List<String> settingNames = [];
    if (bookName.isEmpty || setName.isEmpty) {
      return settingNames;
    }
    try {
      if (_getSettingSortMap(bookName, setName)["settingList"] != null) {
        settingNames = _getSettingSortMap(bookName, setName)["settingList"].cast<String>();
      }
    } on Exception catch (e, s) {
      debugPrint("/// 获取指定设定集下所有设定：从Setting.sort获取设定List（.json文件）");
      GlobalToast.showErrorTop('获取设定集的设定失败');
      debugPrintStack(stackTrace: s);
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
          BookConfig.getDefaultSetSettingJsonString(),
      );

      /// Setting.sort添加设定（新建设定）
      _addNewSettingInSort(bookName, setName, settingName);
      GlobalToast.showSuccessTop('创建设定成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('创建设定失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /// 获取设定的内容：读取设定json文件内容
  Map<String, dynamic> getSettingJson(String bookName, String setName, String settingName) {
    String bookSettingContent = "{}";
    try {
      File file2 = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
      if (file2.existsSync()) {
        bookSettingContent = file2.readAsStringSync();
      }
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('获取设定的内容失败');
      debugPrintStack(stackTrace: s);
    }
    return convert.jsonDecode(bookSettingContent);
  }

  /// 保存设定(json文件)
  void saveSetting(String bookName, String setName, String settingName, String content) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
      if (file.existsSync()) {
        file.writeAsStringSync(content);
      }
      GlobalToast.showSuccessTop('保存设定成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('保存设定失败');
      debugPrintStack(stackTrace: s);
    }

  }

  /// 设定(json文件)重命名
  void renameSetting(String bookName, String setName, String oldSettingName, String newSettingName) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: oldSettingName));
      if (file.existsSync()) {
        file.renameSync(_jsonFilePath(bookName: bookName, setName: setName, settingName: newSettingName));
      }
      /// Setting.sort重命名设定
      _renameSettingInSort(bookName, setName, oldSettingName, newSettingName);
      GlobalToast.showSuccessTop('重命名设定成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('重命名设定失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /// 设定(json文件)删除
  void removeSetting(String bookName, String setName, String settingName) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, setName: setName, settingName: settingName));
      file.deleteSync(recursive: true);
      /// Setting.sort删除设定
      _removeSettingInSort(bookName, setName, settingName);
      GlobalToast.showSuccessTop('删除设定成功');
    } on Exception catch (e, s) {
      GlobalToast.showErrorTop('删除设定失败');
      debugPrintStack(stackTrace: s);
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                (书籍-章节)Chapter.json                                   //
  ////////////////////////////////////////////////////////////////////////////

  /// 创建该书对应Chapter.json：json文件
  void _createBookChapterJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    if (!file2.existsSync()) {
      file2.createSync(recursive: true);
    }
    _saveBookChapterJson(bookName, BookConfig.getDefaultBookChapterJsonString());
  }

  /// Chapter.json读取
  Map<String, dynamic> _getBookChapterJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    String jsonContent = "{}";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("/// Chapter.json读取");
      debugPrintStack(stackTrace: s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// Chapter.json保存（初始化、章节顺序有变化）
  void _saveBookChapterJson(String bookName, String content) {
    File file = File(_jsonFilePath(bookName: bookName, isChapterJson: true));
    if (file.existsSync()) {
      file.writeAsStringSync(content);
    }
  }

  /// Chapter.json操作：添加新建章节
  void _addNewChapterInChapterJson(String bookName, String chapterName) {
    Map<String, dynamic> bookChapterJson = _getBookChapterJsonContent(bookName);
    bookChapterJson["chapterList"].add(chapterName);
    _saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }

  /// Chapter.json操作：删除已有章节
  void _removeChapterInChapterJson(String bookName, String chapterName) {
    Map<String, dynamic> bookChapterJson = _getBookChapterJsonContent(bookName);
    List<String> bookList = bookChapterJson["chapterList"].cast<String>();
    bookList.removeAt(bookList.indexOf(chapterName));
    bookChapterJson["chapterList"] = bookList;
    _saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }

  /// Chapter.json操作：章节重命名
  void _renameChapterInChapterJson(String bookName, String oldChapterName, String newChapterName) {
    Map<String, dynamic> bookChapterJson = _getBookChapterJsonContent(bookName);
    int index = bookChapterJson["chapterList"].indexOf(oldChapterName);
    bookChapterJson["chapterList"][index] = newChapterName;
    _saveBookChapterJson(bookName, convert.jsonEncode(bookChapterJson));
  }
  /////////////////////////////////////////////////////////////////////////////
  //                     (书籍-设定)Set.json                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// 创建该书对应Set.json：json文件
  void _createBookSetJson(String bookName) {
    File file2 = File(_jsonFilePath(bookName: bookName, isSetJson: true));
    if (!file2.existsSync()) {
      file2.createSync(recursive: true);
    }
    _saveBookSetJson(bookName, BookConfig.getDefaultBookSetJsonString());
  }

  /// Set.json读取
  Map<String, dynamic> getBookSetJsonContent(String bookName) {
    File file = File(_jsonFilePath(bookName: bookName, isSetJson: true));
    String jsonContent = "{}";
    try {
      jsonContent = file.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("Set.json读取");
      debugPrintStack(stackTrace: s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// Set.json保存
  void _saveBookSetJson(String bookName, String content) {
    try {
      File file = File(_jsonFilePath(bookName: bookName, isSetJson: true));
      if (file.existsSync()) {
        file.writeAsStringSync(content);
      }
    } on Exception catch (e, s) {
      debugPrint("/// Set.json保存");
      debugPrintStack(stackTrace: s);
    }
  }

  /// Set.json操作：添加新建设定类
  void _addNewSetInSetJson(String bookName, String setName) {
    Map<String, dynamic> bookSetJson = getBookSetJsonContent(bookName);
    /// setList: ["${setName}"]
    bookSetJson["setList"].add(setName);
    /// ${setName}: {"isParsed": true}
    bookSetJson[setName] = {"isParsed": true};
    /// 保存
    _saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：设定集重命名
  void _renameSetInSetJson(String bookName, String oldSetName, String newSetName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    List<String> settingList = bookSetJson["setList"].cast<String>();
    settingList[settingList.indexOf(oldSetName)] = newSetName;
    bookSetJson["setList"] = settingList;
    bookSetJson[newSetName] = bookSetJson.remove(oldSetName);
    /// 保存
    _saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：设定集重命名
  void _removeSetInSetJson(String bookName, String setName) {
    Map<String, dynamic> bookSetJson =  getBookSetJsonContent(bookName);
    List<String> settingList = bookSetJson["setList"].cast<String>();
    settingList.removeAt(settingList.indexOf(setName));
    bookSetJson["setList"] = settingList;
    bookSetJson.remove(setName);
    /// 保存
    _saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /// Set.json操作：修改属性值isParsed（是否加入解析）
  void changeParserOfBookSetJson(String bookName, String setName, bool isParsed) {
    Map<String, dynamic> bookSetJson = getBookSetJsonContent(bookName);
    bookSetJson[setName]["isParsed"] = isParsed;
    /// 保存
    _saveBookSetJson(bookName, convert.jsonEncode(bookSetJson));
  }

  /////////////////////////////////////////////////////////////////////////////
  //                      设定 Setting.sort  (json内容)                       //
  ////////////////////////////////////////////////////////////////////////////
  /// 创建Setting.sort文件
  void _createSettingSort(String bookName, String setName) {
    File file2 = File(_sortFilePath(bookName: bookName, setName: setName));
    if (!file2.existsSync()) {
      file2.createSync(recursive: true);
    }
    file2.writeAsStringSync(BookConfig.getDefaultBookSettingSortJsonString());
  }
  /// Setting.sort文件: 保存内容
  void _saveSettingSort(String bookName, String setName, String content) {
    try {
      File file2 = File(_sortFilePath(bookName: bookName, setName: setName));
      if (file2.existsSync()) {
        file2.writeAsStringSync(content);
      }
    } on Exception catch (e, s) {
      debugPrint("/// Setting.sort文件: 保存内容");
      debugPrintStack(stackTrace: s);
    }
  }
  /// Setting.sort文件: 获取内容
  Map<String, dynamic> _getSettingSortMap(String bookName, String setName) {
    String jsonContent = "{}";
    try {
      File file = File(_sortFilePath(bookName: bookName, setName: setName));
      if (file.existsSync()) {
        jsonContent = file.readAsStringSync();
      }
    } on Exception catch (e, s) {
      debugPrint("/// Setting.sort文件: 获取内容");
      debugPrintStack(stackTrace: s);
    }
    return convert.jsonDecode(jsonContent);
  }
  /// Setting.sort文件: 添加设定
  void _addNewSettingInSort(String bookName, String setName, String settingName) {
    try {
      Map<String, dynamic> sortMap = _getSettingSortMap(bookName, setName);
      // List<String> settingList = sortMap["settingList"].cast<String>();
      // 添加item
      sortMap["settingList"].add(settingName);
      // sortMap["settingList"] = settingList;
      _saveSettingSort(bookName, setName, convert.jsonEncode(sortMap));
    } on Exception catch (e, s) {
      debugPrint("/// Setting.sort文件: 添加设定");
      debugPrintStack(stackTrace: s);
    }
  }
  /// Setting.sort文件: 设定重命名
  void _renameSettingInSort(String bookName, String setName, String oldSettingName, String newSettingName) {
    try {
      Map<String, dynamic> sortMap = _getSettingSortMap(bookName, setName);
      List<String> settingList = sortMap["settingList"].cast<String>();
      // 更换item
      settingList[settingList.indexOf(oldSettingName)] = newSettingName;

      sortMap["settingList"] = settingList;
      _saveSettingSort(bookName, setName, convert.jsonEncode(sortMap));
    } on Exception catch (e, s) {
      debugPrint("/// Setting.sort文件: 设定重命名");
      debugPrintStack(stackTrace: s);
    }
  }
  /// Setting.sort文件: 设定重命名
  void _removeSettingInSort(String bookName, String setName, String settingName) {
    try {
      Map<String, dynamic> sortMap = _getSettingSortMap(bookName, setName);
      List<String> settingList = sortMap["settingList"].cast<String>();
      // 移除item
      settingList.removeAt(settingList.indexOf(settingName));

      sortMap["settingList"] = settingList;
      _saveSettingSort(bookName, setName, convert.jsonEncode(sortMap));
    } on Exception catch (e, s) {
      debugPrint("/// Setting.sort文件: 设定重命名");
      debugPrintStack(stackTrace: s);
    }
  }
}