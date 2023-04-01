import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'file_configure.dart';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';
import 'package:writing_writer/service/config/UserConfig.dart';

class ConfigIOBase
{
  /// 电脑文档目录路径
  late final String _appDocPath;

  ConfigIOBase() {
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
    /// 创建应用文件夹: wWriter/
    Directory rootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.rootDirPath()}");
    if (!rootDir.existsSync()){
      rootDir.createSync(recursive: true);
    }

    /// 创建应用子文件夹：应用配置文件夹 wWriter/config/
    Directory configRootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.configRootDirPath()}");
    if (!configRootDir.existsSync()){
      configRootDir.createSync(recursive: true);
    }

    /// 创建应用子文件：应用配置文件 wWriter/config/user.json
    File userJsonFile = File("$_appDocPath${Platform.pathSeparator}${FileConfig.configUserFilePath()}");
    if (!userJsonFile.existsSync()){
      userJsonFile.createSync(recursive: true);
      userJsonFile.writeAsStringSync(UserConfig.getDefaultUserJsonString());
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  //                              user.json                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// user.json读取
  Map<String, dynamic> getUserJsonContent() {
    File userJsonFile = File("$_appDocPath${Platform.pathSeparator}${FileConfig.configUserFilePath()}");
    String jsonContent = "";
    try {
      jsonContent = userJsonFile.readAsStringSync();
    } on Exception catch (e, s) {
      debugPrint("user.json读取");
      print(s);
    }
    return convert.jsonDecode(jsonContent);
  }

  /// user.json保存
  void saveUserJson(Map<String, dynamic> userJson) {
    try {
      File userJsonFile = File("$_appDocPath${Platform.pathSeparator}${FileConfig.configUserFilePath()}");
      if (!userJsonFile.existsSync()) {
        userJsonFile.createSync(recursive: true);
      }
      userJsonFile.writeAsStringSync(convert.jsonEncode(userJson));
    } on Exception catch (e, s) {
      debugPrint("/// user.json保存");
      print(s);
    }
  }

  /// 存储 webDAV 信息
  void storeWevDAV(String uri, String user, String password) {
    Map<String, dynamic> userJson = getUserJsonContent();
    userJson["webDAV"] = {
      "uri": uri,
      "user": user,
      "password": password,
    };
    saveUserJson(userJson);
  }

  /// 获取 webDAV 信息
  Map<String, dynamic> getWevDAV() {
    Map<String, dynamic> userJson = getUserJsonContent();
    return userJson["webDAV"];
  }
}