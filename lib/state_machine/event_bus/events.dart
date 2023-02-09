// All events defined here

/// <!-- Book -->
/// CreateNewBook
class CreateNewBookEvent {}
/// RenameBookNameEvent
class RenameBookNameEvent {}

/// <!-- Chapter -->
/// CreateNewChapter
class CreateNewChapterEvent {
  String bookName;
  CreateNewChapterEvent(this.bookName);
}

/// <!-- Set -->
/// CreateNewSet
class CreateNewSetEvent {}
/// RenameSet
class RenameSetEvent {}

/// <!-- Setting -->
/// createSetting
class CreateNewSettingEvent {}