import 'dart:io';

class FileConfig {
  /// writing writer 根文件夹名称
  static String rootName = "wWriter";

  /// writing writer 写作内容根文件夹名称
  static String writeRootName = "write";
  /// writing writer 写作内容子文件夹名称
  static String writeSetDirName = "Set";
  static String writeChapterDirName = "Chapter";
  static String writeSettingSortFileName = "Setting";

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

  /// writing writer webdav内容中间站根文件夹名称
  static String webDAVRootName = "webdav";

  /// 文件格式后缀
  static String chsFilePostfix = ".txt";
  static String jsonFilePostfix = ".json";
  static String zipFilePostfix = ".zip";
  static String sortFilePostfix = ".sort";

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
  /// wWriter/write/${bookName}/Set/${setName}/Setting.sort
  static String writeBookSettingSortFilePath(String bookName, String setName) {
    return writeBookSetDirPath(bookName, setName) + Platform.pathSeparator + writeSettingSortFileName + sortFilePostfix;
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
  /// 云端网盘路径：/wWriter
  static String webDAVRootDirPath() {
    return "/${rootDirPath()}";
  }
  /// 云端网盘路径：/wWriter/${bookName}.zip
  static String webDAVBookFilePath(String bookName) {
    return "${webDAVRootDirPath()}/$bookName$zipFilePostfix";
  }
  /// 本地暂时路径：wWriter/webdav
  static String webDAVLocalRootDirPath() {
    return rootDirPath() + Platform.pathSeparator + webDAVRootName;
  }
  /// 本地暂时路径：wWriter/webdav/${bookName}.zip
  static String webDAVLocalBookFilePath(String bookName) {
    return webDAVLocalRootDirPath() + Platform.pathSeparator + bookName + zipFilePostfix;
  }
}
/// — —  wWriter
///   — — — —  write
///     — — — — — —  ${bookName}
///       — — — — — — — — — —  Chapter.json
///       — — — — — — — — — —  Chapter
///         — — — — — — — — — — — —  ${chapterName}.txt
///       — — — — — — — — — —  Set
///         — — — — — — — — — — — —  Set.json
///         — — — — — — — — — — — —  ${setName}
///           — — — — — — — — — — — — — —  ${settingName}.json
///           — — — — — — — — — — — — — —  Setting.sort
///   — — — —  export
///     — — — — — —  ${bookName}
///       — — — — — — — —  chs
///         — — — — — — — — — —  ${chapterName}.txt
///       — — — — — — — —  bok
///         — — — — — — — — — —  1.${chapterName}.txt
///         — — — — — — — — — —  2.${chapterName}.txt
///         — — — — — — — — — —  ······
///       — — — — — — — —  zip
///         — — — — — — — — — —  ${bookName}.zip
///   — — — —  webdav
///     — — — — — —  ${bookName}.zip
///   — — — —  config
///     — — — — — —  user.json