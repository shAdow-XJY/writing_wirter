import 'package:collection/collection.dart';

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

  /// parser 对象变量构造
  static Map<String, Set<String>> addSetToParser(Map<String, Set<String>> currentParser, String setName, List<String> settingsList) {
    Map<String, Set<String>> newObj = deepClone(currentParser);
    newObj[setName] = <String>{};
    newObj[setName]?.addAll(settingsList);
    return newObj;
  }

  /// parser 对象变量比较
  /// equals : true
  static bool compareParser(Map<String, Set<String>> parserOne, Map<String, Set<String>> parserTwo) {
    return const DeepCollectionEquality().equals(parserOne, parserTwo);
  }

  /// Map<String, Set<String>> 深拷贝
  static Map<String, Set<String>> deepClone(Map<String, Set<String>> parser) {
    Map<String, Set<String>> newObj = {};
    parser.forEach((set, settings) {
      newObj[set] = <String>{};
      newObj[set]?.addAll(settings);
    });
    return newObj;
  }
}