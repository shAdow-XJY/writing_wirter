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
  String chapterName;
  CreateNewChapterEvent({required this.bookName, required this.chapterName});
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
class RenameSetEvent {
  String oldSetName;
  String newSetName;
  RenameSetEvent({required this.oldSetName, required this.newSetName});
}
/// RemoveSetEvent
class RemoveSetEvent {
  String setName;
  RemoveSetEvent({required this.setName});
}

/// <!-- Setting -->
/// createSetting
class CreateNewSettingEvent {
  String setName;
  String settingName;
  CreateNewSettingEvent({required this.setName, required this.settingName});
}
/// RenameSetting
class RenameSettingEvent {
  String setName;
  String oldSettingName;
  String newSettingName;
  RenameSettingEvent({required this.setName, required this.oldSettingName, required this.newSettingName});
}
/// RemoveSettingEvent
class RemoveSettingEvent {
  String setName;
  String settingName;
  RemoveSettingEvent({required this.setName, required this.settingName});
}