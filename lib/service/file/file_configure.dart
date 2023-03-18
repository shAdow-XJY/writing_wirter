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

  /// 文件格式后缀
  static String chsFilePostfix = ".txt";
  static String jsonFilePostfix = ".json";

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