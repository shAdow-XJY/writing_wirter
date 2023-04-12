// All events defined here

/// <!-- Book -->
/// CreateNewBook
class CreateNewBookEvent {}
/// RenameBookNameEvent
class RenameBookNameEvent {
  String oldBookName;
  String newBookName;
  RenameBookNameEvent({required this.oldBookName, required this.newBookName});
}
/// RemoveBook
class RemoveBookEvent {
  String bookName;
  RemoveBookEvent({required this.bookName});
}

/// <!-- Chapter -->
/// CreateNewChapter
class CreateNewChapterEvent {
  String bookName;
  CreateNewChapterEvent(this.bookName);
}
/// RenameChapterNameEvent
class RenameChapterNameEvent {
  String bookName;
  String oldChapterName;
  String newChapterName;
  RenameChapterNameEvent({required this.bookName, required this.oldChapterName, required this.newChapterName});
}
/// RenameChapterNameEvent
class RemoveChapterEvent {
  String bookName;
  String chapterName;
  RemoveChapterEvent({required this.bookName, required this.chapterName});
}

/// <!-- Set -->
/// CreateNewSet
class CreateNewSetEvent {}
/// RenameSet
class RenameSetEvent {}

/// <!-- Setting -->
/// createSetting
class CreateNewSettingEvent {}
