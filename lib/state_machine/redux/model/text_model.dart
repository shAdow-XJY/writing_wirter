class TextModel {
  /// 当前选中的书名
  String currentBook;
  /// 当前选中的章节
  String currentChapter;
  /// 当前选中的章节的章节数
  String currentChapterNumber;

  TextModel({
    required this.currentBook,
    required this.currentChapter,
    required this.currentChapterNumber,
  });
}
