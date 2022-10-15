import 'package:flutter/material.dart';
import 'package:writing_writer2/redux/model/set_model.dart';
import '../../server/file/IOBase.dart';
import '../action/set_action.dart';
import '../action/text_action.dart';
import '../model/text_model.dart';

class AppState {

  /// current text show info
  late TextModel textModel;
  /// current set show info
  late SetModel setModel;
  ///
  late IOBase ioBase;

  AppState({
    required this.textModel,
    required this.setModel,
    required this.ioBase,
  });

  /*
   * 命名的构造方法
   * 这里用来初始化
   */
  AppState.initialState() {
    textModel = TextModel(currentBook: "", currentChapter: "");
    setModel = SetModel(currentSet: "", currentSetting: "");
    ioBase = IOBase();
  }

  AppState copyWith ({textModel, setModel}){
    return AppState(
      textModel: textModel ?? this.textModel,
      setModel: setModel ?? this.setModel,
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
    case SetSetDataAction:
    {
      return state.copyWith(setModel: setReducer(state.setModel, action));
    }
    default:
    {
      return state;
    }
  }

}
