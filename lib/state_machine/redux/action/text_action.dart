import 'package:redux/redux.dart';
import '../model/text_model.dart';

class SetTextDataAction{
  String currentBook;
  String currentChapter;
  String currentChapterNumber;

  SetTextDataAction({
    required this.currentBook,
    required this.currentChapter,
    this.currentChapterNumber = "1",
  });

  static TextModel setText(TextModel textModel, SetTextDataAction action) {
    textModel.currentBook = action.currentBook;
    textModel.currentChapter = action.currentChapter;
    textModel.currentChapterNumber = action.currentChapterNumber;
    return textModel;
  }

}

/*
 * 绑定Action与动作
 */
final textReducer = combineReducers<TextModel>([
  TypedReducer<TextModel, SetTextDataAction>(SetTextDataAction.setText),
]);