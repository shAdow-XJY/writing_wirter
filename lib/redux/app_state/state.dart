import 'package:flutter/material.dart';
import '../../server/file/IOBase.dart';
import '../action/text_action.dart';
import '../model/text_model.dart';

class AppState {

  /// current text show info
  late TextModel textModel;
  ///
  late IOBase ioBase;

  AppState({
    required this.textModel,
    required this.ioBase,
  });

  /*
   * 命名的构造方法
   * 这里用来初始化
   */
  AppState.initialState() {
    textModel = TextModel(currentBook: "", currentChapter: "");
    ioBase = IOBase();
  }

  AppState copyWith ({textModel}){
    return AppState(
      textModel: textModel,
      ioBase: ioBase,
    );
  }

}

/**
 * 定义Reducer
 */
AppState appReducer(AppState state, action) {
  debugPrint(action.runtimeType.toString());
  switch(action.runtimeType){
    case SetTextDataAction:
    {
      return state.copyWith(textModel: textReducer(state.textModel, action));
    }
    default:
    {
      return state;
    }
  }

}
