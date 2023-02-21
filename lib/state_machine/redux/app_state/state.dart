import 'package:flutter/material.dart';
import '../action/parser_action.dart';
import '../action/set_action.dart';
import '../action/text_action.dart';
import '../model/parser_model.dart';
import '../model/set_model.dart';
import '../model/text_model.dart';

class AppState {

  /// current text show info
  late TextModel textModel;
  /// current set show info
  late SetModel setModel;
  /// all set obj
  late ParserModel parserModel;

  AppState({
    required this.textModel,
    required this.setModel,
    required this.parserModel,
  });

  /*
   * 命名的构造方法
   * 这里用来初始化
   */
  AppState.initialState() {
    textModel = TextModel(currentBook: "", currentChapter: "", currentChapterNumber: "1");
    setModel = SetModel(currentSet: "", currentSetting: "");
    parserModel = ParserModel(parserObj: {});
  }

  AppState copyWith ({textModel, setModel, styleModel, parserModel}){
    return AppState(
      textModel: textModel ?? this.textModel,
      setModel: setModel ?? this.setModel,
      parserModel: this.textModel.currentBook.compareTo(textModel != null ? textModel!.currentBook : this.textModel.currentBook) == 0
          ? (parserModel ?? this.parserModel)
          : ParserModel(parserObj: {}),
    );
  }

}

/// 定义Reducer
AppState appReducer(AppState state, action) {
  debugPrint(action.runtimeType.toString());
  switch(action.runtimeType) {
    case SetTextDataAction: {
      return state.copyWith(textModel: textReducer(state.textModel, action));
    }
    case SetSetDataAction: {
      return state.copyWith(setModel: setReducer(state.setModel, action));
    }
    case SetParserDataAction: {
      return state.copyWith(parserModel: parserReducer(state.parserModel, action));
    }
    default:{
      return state;
    }
  }

}
