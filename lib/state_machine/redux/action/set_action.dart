import 'package:redux/redux.dart';

import '../model/set_model.dart';

class SetSetDataAction{
  String currentSet;
  String currentSetting;

  SetSetDataAction({
    required this.currentSet,
    required this.currentSetting,
  });

  static SetModel setSet(SetModel setModel, SetSetDataAction action) {
    setModel.currentSet = action.currentSet;
    setModel.currentSetting = action.currentSetting;
    return setModel;
  }

}

/*
 * 绑定Action与动作
 */
final setReducer = combineReducers<SetModel>([
  TypedReducer<SetModel, SetSetDataAction>(SetSetDataAction.setSet),
]);