class Parser
{
  static Map<String, Set<String>> addSetToParser(Map<String, Set<String>> currentParser, String addedSetName, List<String> addedSettingsName) {
    currentParser[addedSetName]?.addAll(addedSettingsName);
    return currentParser;
  }

  static Map<String, Set<String>> addSettingToParser(Map<String, Set<String>> currentParser, String addedSetName, String addedSettingName) {
    currentParser[addedSetName]?.add(addedSettingName);
    return currentParser;
  }

  static Map<String, Set<String>> removeSetInParser(Map<String, Set<String>> currentParser, String removedSetName) {
    currentParser[removedSetName] = <String>{};
    return currentParser;
  }

  static Map<String, Set<String>> removeSettingInParser(Map<String, Set<String>> currentParser, String removedSetName, String removedSettingName) {
    currentParser[removedSetName]?.remove(removedSettingName);
    return currentParser;
  }
}