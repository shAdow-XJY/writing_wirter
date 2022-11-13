import 'package:redux/redux.dart';

import '../model/parser_model.dart';

class SetParserDataAction{
  /// 当前设定集解析加入展示
  Map<String, Set<String>> currentParser;

  SetParserDataAction({
    required this.currentParser,
  });

  static ParserModel setParser(ParserModel parserModel, SetParserDataAction action) {
    parserModel.currentParser = action.currentParser;
    return parserModel;
  }

}

/*
 * 绑定Action与动作
 */
final parserReducer = combineReducers<ParserModel>([
  TypedReducer<ParserModel, SetParserDataAction>(SetParserDataAction.setParser),
]);