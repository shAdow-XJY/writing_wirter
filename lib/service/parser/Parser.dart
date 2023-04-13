// ignore_for_file: file_names

import 'package:collection/collection.dart';
import 'package:writing_writer/service/file/IOBase.dart';

class Parser
{
  static RegExp generateRegExp(Map<String, Set<String>> parser) {
    String regExpString = '';
    parser.forEach((set, settings) {
      for (var setting in settings) {
        regExpString += setting.toString();
        regExpString += '|';
      }
    });
    RegExp result = RegExp(r'' + regExpString);
    // print(result);
    return result;
  }

  /// parser 对象: 添加元素
  static Map<String, Set<String>> addSetToParser(Map<String, Set<String>> currentParser, String setName, List<String> settingsList) {
    Map<String, Set<String>> newObj = deepClone(currentParser);
    newObj[setName] = <String>{};
    newObj[setName]?.addAll(settingsList);
    return newObj;
  }

  /// parser 对象: 删除元素
  static Map<String, Set<String>> removeSetFromParser(Map<String, Set<String>> currentParser, String setName) {
    Map<String, Set<String>> newObj = deepClone(currentParser);
    if (newObj.containsKey(setName)) {
      newObj.remove(setName);
    }
    return newObj;
  }

  /// parser 对象: 替换元素
  static Map<String, Set<String>> replaceSetInParser(Map<String, Set<String>> currentParser, String oldSetName, String newSetName) {
    Map<String, Set<String>> newObj = deepClone(currentParser);
    newObj[newSetName] = newObj.remove(oldSetName)!;
    return newObj;
  }

  /// parser 对象: 替换元素
  static Map<String, Set<String>> replaceSettingInParser(Map<String, Set<String>> currentParser, String setName, String oldSettingName, String newSettingName) {
    Map<String, Set<String>> newObj = deepClone(currentParser);
    newObj[setName]?.remove(oldSettingName);
    newObj[setName]?.add(newSettingName);
    return newObj;
  }

  /// parser 对象变量比较
  /// equals : true
  static bool compareParser(Map<String, Set<String>> parserOne, Map<String, Set<String>> parserTwo) {
    return const DeepCollectionEquality().equals(parserOne, parserTwo);
  }

  /// Map<String, Set<String>> 对象深拷贝
  static Map<String, Set<String>> deepClone(Map<String, Set<String>> parser) {
    Map<String, Set<String>> newObj = {};
    parser.forEach((set, settings) {
      newObj[set] = <String>{};
      newObj[set]?.addAll(settings);
    });
    return newObj;
  }

  /// parser 对象: 整本书最开始的parserModel获取（在点击另一本书的章节时调用）
  static Map<String, Set<String>> getBookInitParserModel(IOBase ioBase, String bookName) {
    Map<String, Set<String>> newParserModel = {};
    Map<String, dynamic> setJson = ioBase.getBookSetJsonContent(bookName);
    List<String> setList = setJson["setList"].cast<String>() ?? [];
    for (var setName in setList) {
      if (setJson[setName]["isParsed"]) {
        newParserModel = addSetToParser(newParserModel, setName, ioBase.getAllSettings(bookName, setName));
      }
    }
    // print(newParserModel);
    return newParserModel;
  }
}