import 'package:redux/redux.dart';
import '../model/parser_model.dart';

class SetParserDataAction{
  Map<String, Set<String>> parserObj;

  SetParserDataAction({
    required this.parserObj,
  });

  static ParserModel setParser(ParserModel parserModel, SetParserDataAction action) {
    parserModel.parserObj = action.parserObj;
    return parserModel;
  }

}

/*
 * 绑定Action与动作
 */
final parserReducer = combineReducers<ParserModel>([
  TypedReducer<ParserModel, SetParserDataAction>(SetParserDataAction.setParser),
]);