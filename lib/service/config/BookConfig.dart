// ignore_for_file: file_names

import 'dart:convert' as convert;

class BookConfig {

  /// default book-chapter : Chapter.json
  static String getDefaultBookChapterJsonString() {
    return convert.jsonEncode(getDefaultBookChapterJson());
  }

  /// default book-set : Set.json
  static String getDefaultBookSetJsonString() {
    return convert.jsonEncode(getDefaultBookSetJson());
  }
  /// default set-setting.sort : Setting.sort
  static String getDefaultBookSettingSortJsonString() {
    return convert.jsonEncode(getDefaultBookSettingSortJson());
  }
  /// default set-setting : {$settingName}.json
  static String getDefaultSetSettingJsonString() {
    return convert.jsonEncode(getDefaultSetSettingJson());
  }

  /// default book-chapter : Chapter.json
  static Map<String, Object> getDefaultBookChapterJson()
  {
    return {
      "chapterList": []
    };
  }

  /// default book-set : Set.json
  static Map<String, Object> getDefaultBookSetJson()
  {
    return {
      "setList": [
        // "setName"
      ],
      // "${setName}": {
      //   "isParsed": true,
      // }
    };
  }

  /// default set-setting.sort : Setting.sort
  static Map<String, Object> getDefaultBookSettingSortJson()
  {
    return {
      "settingList": [
        // "setName"
      ],
    };
  }

  /// default set-setting : {$settingName}.json
  static Map<String, Object> getDefaultSetSettingJson()
  {
    return {
      "chapterFlags": ['1'],
      "information": [
        {
          "img_url": "",
          "description": ""
        }
      ]
    };
  }

}