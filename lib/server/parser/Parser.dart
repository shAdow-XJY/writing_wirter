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
    currentParser[setName] = <String>{};
    currentParser[setName]?.addAll(settingsList);
    return currentParser;
  }

  /// parser 对象变量比较
  static bool compareParser(Map<String, Set<String>> parserOne, Map<String, Set<String>> parserTwo) {
    return const DeepCollectionEquality().equals(parserOne, parserTwo);
  }

  // static Map<String, Set<String>> addSetToParser(Map<String, Set<String>> currentParser, String addedSetName, List<String> addedSettingsName) {
  //   currentParser[addedSetName]?.addAll(addedSettingsName);
  //   return currentParser;
  // }
  //
  // static Map<String, Set<String>> addSettingToParser(Map<String, Set<String>> currentParser, String addedSetName, String addedSettingName) {
  //   currentParser[addedSetName]?.add(addedSettingName);
  //   return currentParser;
  // }
  //
  // static Map<String, Set<String>> removeSetInParser(Map<String, Set<String>> currentParser, String removedSetName) {
  //   currentParser[removedSetName] = <String>{};
  //   return currentParser;
  // }
  //
  // static Map<String, Set<String>> removeSettingInParser(Map<String, Set<String>> currentParser, String removedSetName, String removedSettingName) {
  //   currentParser[removedSetName]?.remove(removedSettingName);
  //   return currentParser;
  // }

}