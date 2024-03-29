// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../encrypt/encryption_helper.dart';
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
      String decryptedStr = UserConfig.getDefaultUserJsonString();
      userJsonFile.writeAsStringSync(EncryptionHelper.getEncryptedString(decryptedStr));
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
      jsonContent = EncryptionHelper.getDecryptedString(jsonContent);
    } on Exception catch (e, s) {
      debugPrint("user.json读取");
      debugPrintStack(stackTrace: s);
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
      String decryptedStr = convert.jsonEncode(userJson);
      userJsonFile.writeAsStringSync(EncryptionHelper.getEncryptedString(decryptedStr));
    } on Exception catch (e, s) {
      debugPrint("/// user.json保存");
      debugPrintStack(stackTrace: s);
    }
  }

  /// 存储 webDAV 信息
  void storeWevDAVInfo(String uri, String user, String password) {
    Map<String, dynamic> userJson = getUserJsonContent();
    userJson["webDAV"] = {
      "uri": uri,
      "user": user,
      "password": password,
    };
    saveUserJson(userJson);
  }

  /// 获取 webDAV 信息
  Map<String, dynamic> getWevDAVInfo() {
    Map<String, dynamic> userJson = getUserJsonContent();
    return userJson["webDAV"];
  }
}