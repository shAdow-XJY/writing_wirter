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

/// <!-- Set -->
/// CreateNewSet
class CreateNewSetEvent {}
/// RenameSet
class RenameSetEvent {}

/// <!-- Setting -->
/// createSetting
class CreateNewSettingEvent {}
