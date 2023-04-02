import 'dart:io';

class FileConfig {
  /// writing writer 根文件夹名称
  static String rootName = "wWriter";

  /// writing writer 写作内容根文件夹名称
  static String writeRootName = "write";
  /// writing writer 写作内容子文件夹名称
  static String writeSetDirName = "Set";
  static String writeChapterDirName = "Chapter";

  /// writing writer 导出内容根文件夹名称
  static String exportRootName = "export";
  /// writing writer 导出内容子文件夹名称
  static String exportChapterDirName = "chs";
  static String exportBookDirName = "bok";
  static String exportZipDirName = "zip";

  /// writing writer 应用配置根文件夹名称
  static String configRootName = "config";
  /// writing writer 应用配置内容子文件名称
  static String configUserFileName = "user";

  /// 文件格式后缀
  static String chsFilePostfix = ".txt";
  static String jsonFilePostfix = ".json";
  static String zipFilePostfix = ".zip";

  /// 文件相对路径函数
  /// wWriter
  static String rootDirPath() {
    return rootName;
  }

  /// 写作部分
  /// wWriter/write
  static String writeRootDirPath() {
    return rootDirPath() + Platform.pathSeparator + writeRootName;
  }
  /// wWriter/write/${bookName}
  static String writeBookDirPath(String bookName) {
    return writeRootDirPath() + Platform.pathSeparator + bookName;
  }
  /// 写作部分: 设定集
  /// wWriter/write/${bookName}/Set
  static String writeBookSetRootDirPath(String bookName) {
    return writeBookDirPath(bookName) + Platform.pathSeparator + writeSetDirName;
  }
  /// wWriter/write/${bookName}/Set/Set.json
  static String writeBookSetJsonFilePath(String bookName) {
    return writeBookSetRootDirPath(bookName) + Platform.pathSeparator + writeSetDirName + jsonFilePostfix;
  }
  /// wWriter/write/${bookName}/Set/${setName}
  static String writeBookSetDirPath(String bookName, String setName) {
    return writeBookSetRootDirPath(bookName) + Platform.pathSeparator + setName;
  }
  /// wWriter/write/${bookName}/Set/${setName}/${settingName}.json
  static String writeBookSettingJsonFilePath(String bookName, String setName, String settingName) {
    return writeBookSetDirPath(bookName, setName) + Platform.pathSeparator + settingName + jsonFilePostfix;
  }
  /// 写作部分: 章节
  /// wWriter/write/${bookName}/Chapter.json
  static String writeBookChapterJsonFilePath(String bookName) {
    return writeBookDirPath(bookName) + Platform.pathSeparator + writeChapterDirName + jsonFilePostfix;
  }
  /// wWriter/write/${bookName}/Chapter
  static String writeBookChapterDirPath(String bookName) {
    return writeBookDirPath(bookName) + Platform.pathSeparator + writeChapterDirName;
  }
  /// wWriter/write/${bookName}/Chapter/${chapterName}.txt
  static String writeBookChapterFilePath(String bookName, String chapterName) {
    return writeBookChapterDirPath(bookName) + Platform.pathSeparator + chapterName + chsFilePostfix;
  }

  /// 导出部分
  /// wWriter/export
  static String exportRootDirPath() {
    return rootDirPath() + Platform.pathSeparator + exportRootName;
  }
  /// wWriter/export/${bookName}
  static String exportBookDirPath(String bookName) {
    return exportRootDirPath() + Platform.pathSeparator + bookName;
  }
  /// 导出部分: 导出章节
  /// wWriter/export/${bookName}/chs
  static String exportBookChsDirPath(String bookName) {
    return exportBookDirPath(bookName) + Platform.pathSeparator + exportChapterDirName;
  }
  /// wWriter/export/${bookName}/chs/${chapterName}.txt
  static String exportBookChapterFilePath(String bookName, String chapterName) {
    return exportBookChsDirPath(bookName) + Platform.pathSeparator + chapterName + chsFilePostfix;
  }
  /// 导出部分: 导出书籍
  /// wWriter/export/${bookName}/bok
  static String exportBookBokDirPath(String bookName) {
    return exportBookDirPath(bookName) + Platform.pathSeparator + exportBookDirName;
  }
  /// wWriter/export/${bookName}/bok/${index}${chapterName}.txt
  static String exportBookBokChapterFilePath(String bookName, int index, String chapterName) {
    return exportBookBokDirPath(bookName) + Platform.pathSeparator + index.toString() + chapterName + chsFilePostfix;
  }
  /// 导出部分: 导出.zip文件
  /// wWriter/export/${bookName}/zip
  static String exportBookZipDirPath(String bookName) {
    return exportBookDirPath(bookName) + Platform.pathSeparator + exportZipDirName;
  }
  /// wWriter/export/${bookName}/zip/${bookName}.zip
  static String exportBookZipFilePath(String bookName) {
    return exportBookZipDirPath(bookName) + Platform.pathSeparator + bookName + zipFilePostfix;
  }

  /// 用户配置部分
  /// wWriter/user
  static String configRootDirPath() {
    return rootDirPath() + Platform.pathSeparator + configRootName;
  }
  /// wWriter/user/userConfigFileName.json
  static String configUserFilePath() {
    return configRootDirPath() + Platform.pathSeparator + configUserFileName + jsonFilePostfix;
  }

  /// webDAV部分
  /// /wWriter
  static String webDAVRootDirPath() {
    return "/${rootDirPath()}";
  }
  /// /wWriter/${bookName}.zip
  static String webDAVBookFilePath(String bookName) {
    return "${webDAVRootDirPath()}/$bookName$zipFilePostfix";
  }
}
/// 书籍结构实例：
/// 书名：西游记
/// 章节：第一回　灵根育孕源流出　心性修持大道生
/// 设定集： 人物集
/// 设定： 孙悟空
/// — —  wWriter
///   — — — —  write
///     — — — — — —  西游记
///       — — — — — — — — — —  Chapter.json
///       — — — — — — — — — —  Chapter
///         — — — — — — — — — — — —  第一回　灵根育孕源流出　心性修持大道生.txt
///       — — — — — — — — — —  Set
///         — — — — — — — — — — — —  Set.json
///         — — — — — — — — — — — —  人物集
///           — — — — — — — — — — — — — —  孙悟空.json
///   — — — —  export
///     — — — — — —  西游记
///       — — — — — — — —  chs
///         — — — — — — — — — —  第一回　灵根育孕源流出　心性修持大道生.txt
///       — — — — — — — —  bok
///         — — — — — — — — — —  1.第一回　灵根育孕源流出　心性修持大道生.txt
///         — — — — — — — — — —  ······
///       — — — — — — — —  zip
///         — — — — — — — — — —  西游记.zip