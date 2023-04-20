// ignore_for_file: file_names

import 'dart:convert' as convert;

class UserConfig {

  /// default : user.json
  static String getDefaultUserJsonString() {
    return convert.jsonEncode(getDefaultUserJson());
  }

  /// default : user.json
  static Map<String, Object> getDefaultUserJson()
  {
    return {
      "webDAV": {
        "uri": "",
        "user": "",
        "password": "",
      }
    };
  }
}