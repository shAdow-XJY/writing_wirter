// TODO Implement this library.
import 'dart:convert' as convert;

class BookConfig {

  /// default book-chapter : {$bookName}Chapter.json
  static String getDefaultBookChapterJsonString({String bookName = ""}) {
    return convert.jsonEncode(getDefaultBookChapterJson(bookName: bookName));
  }

  /// default book-set : {$bookName}Set.json
  static String getDefaultBookSetJsonString({String bookName = ""}) {
    return convert.jsonEncode(getDefaultBookSetJson(bookName: bookName));
  }

  /// default set-setting : {$settingName}.json
  static String getDefaultSetSettingJsonString({String bookName = "", String setName = "", String settingName = ""}) {
    return convert.jsonEncode(getDefaultSetSettingJson(bookName: bookName, setName: setName, settingName: settingName));
  }

  /// default book-chapter : {$bookName}Chapter.json
  static Map<String, Object> getDefaultBookChapterJson({String bookName = ""})
  {
    return {
      "bookName": bookName,
      "chapterList": []
    };
  }

  /// default book-set : {$bookName}Set.json
  static Map<String, Object> getDefaultBookSetJson({String bookName = ""})
  {
    return {
      "bookName": bookName,
      "setList": [
        // {
        //   "setName": "",
        //   "addToParser": true,
        // }
      ],
      // "setName": {
      //   "settingList": ["settingName"]
      // }
    };
  }

  /// default set-setting : {$settingName}.json
  static Map<String, Object> getDefaultSetSettingJson({String bookName = "", String setName = "", String settingName = ""})
  {
    return {
      "bookName": bookName,
      "setName": setName,
      "settingName": settingName,
      "chapterFlag": ['1'],
      "information": [
        {
          "img_url": "",
          "description": ""
        }
      ]
    };
  }

}