// TODO Implement this library.
import 'dart:convert' as convert;

class BookConfig {

  BookConfig() {}

  static String getDefaultBookString({String bookName = ""}) {
    return convert.jsonEncode(getDefaultBook(bookName: bookName));
  }

  static String getDefaultSettingString({String bookName = "", String setName = "", String settingName = ""}) {
    return convert.jsonEncode(getDefaultSetting(bookName: bookName, setName: setName, settingName: settingName));
  }

  /// default book json
  static Map<String, Object> getDefaultBook({String bookName = ""})
  {
    return {
      "bookName": bookName,
      "chapterList": []
    };
  }

  /// default setting json
  static Map<String, Object> getDefaultSetting({String bookName = "", String setName = "", String settingName = ""})
  {
    return {
      "bookName": bookName,
      "setName": setName,
      "settingName": settingName,
      "chapterFlag": [1],
      "information": {
        "1": {
          "img_url": "",
          "description": ""
        }
      }
    };
  }

}