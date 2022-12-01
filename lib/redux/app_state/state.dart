import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:writing_writer/redux/action/style_action.dart';
import 'package:writing_writer/redux/model/style_model.dart';
import '../../server/file/IOBase.dart';
import '../action/set_action.dart';
import '../action/text_action.dart';
import '../model/set_model.dart';
import '../model/text_model.dart';

class AppState {

  /// current text show info
  late TextModel textModel;
  /// current set show info
  late SetModel setModel;
  /// device style info
  late StyleModel styleModel;
  /// IO tool
  late IOBase ioBase;
  /// all set obj
  late Map<String, Set<String>> parserModel;

  AppState({
    required this.textModel,
    required this.setModel,
    required this.styleModel,
    required this.ioBase,
    required this.parserModel,
  });

  /*
   * 命名的构造方法
   * 这里用来初始化
   */
  AppState.initialState() {
    textModel = TextModel(currentBook: "", currentChapter: "");
    setModel = SetModel(currentSet: "", currentSetting: "");
    styleModel = StyleModel(deviceScreenType: DeviceScreenType.desktop);
    ioBase = IOBase();
    parserModel = {};
  }

  AppState copyWith ({textModel, setModel, styleModel}){
    return AppState(
      textModel: textModel ?? this.textModel,
      setModel: setModel ?? this.setModel,
      styleModel: styleModel ?? this.styleModel,
      ioBase: ioBase,
      parserModel: this.textModel.currentBook.compareTo(textModel != null ? textModel!.currentBook : "") == 0 ? parserModel : {},
    );
  }

}

/**
 * 定义Reducer
 */
AppState appReducer(AppState state, action) {
  debugPrint(action.runtimeType.toString());
  switch(action.runtimeType){
    case SetTextDataAction:{
      return state.copyWith(textModel: textReducer(state.textModel, action));
    }
    case SetSetDataAction:{
      return state.copyWith(setModel: setReducer(state.setModel, action));
    }
    case SetStyleDataAction:{
      return state.copyWith(styleModel: styleReducer(state.styleModel, action));
    }
    default:{
      return state;
    }
  }

}
