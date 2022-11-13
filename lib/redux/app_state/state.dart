import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:writing_writer/redux/action/style_action.dart';
import 'package:writing_writer/redux/model/parser_model.dart';
import 'package:writing_writer/redux/model/style_model.dart';
import '../../server/file/IOBase.dart';
import '../action/parser_action.dart';
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
  /// settings parser info
  late ParserModel parserModel;
  /// IO tool
  late IOBase ioBase;

  AppState({
    required this.textModel,
    required this.setModel,
    required this.styleModel,
    required this.parserModel,
    required this.ioBase,
  });

  /*
   * 命名的构造方法
   * 这里用来初始化
   */
  AppState.initialState() {
    textModel = TextModel(currentBook: "", currentChapter: "");
    setModel = SetModel(currentSet: "", currentSetting: "");
    styleModel = StyleModel(deviceScreenType: DeviceScreenType.desktop);
    parserModel = ParserModel(currentParser: {});
    ioBase = IOBase();
  }

  AppState copyWith ({textModel, setModel, styleModel, parserModel}){
    return AppState(
      textModel: textModel ?? this.textModel,
      setModel: setModel ?? this.setModel,
      styleModel: styleModel ?? this.styleModel,
      parserModel: parserModel ?? this.parserModel,
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
    case SetTextDataAction:{
      return state.copyWith(textModel: textReducer(state.textModel, action));
    }
    case SetSetDataAction:{
      return state.copyWith(setModel: setReducer(state.setModel, action));
    }
    case SetStyleDataAction:{
      return state.copyWith(styleModel: styleReducer(state.styleModel, action));
    }
    case SetParserDataAction:{
      return state.copyWith(parserModel: parserReducer(state.parserModel, action));
    }
    default:{
      return state;
    }
  }

}
