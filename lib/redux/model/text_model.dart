class TextModel {
  /// 当前选中的书名
  String currentBook;
  /// 当前选中的章节
  String currentChapter;
  /// 当前设定集解析加入展示
  Map<String, Set<String>>? currentParser;

  TextModel({
    required this.currentBook,
    required this.currentChapter,
    this.currentParser,
  });
}
