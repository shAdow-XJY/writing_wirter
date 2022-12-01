import 'package:redux/redux.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../model/style_model.dart';

class SetStyleDataAction{
  DeviceScreenType deviceScreenType;

  SetStyleDataAction({
    required this.deviceScreenType,
  });

  static StyleModel setSet(StyleModel styleModel, SetStyleDataAction action) {
    return styleModel.deviceScreenType == action.deviceScreenType
        ? styleModel
        : StyleModel(deviceScreenType: action.deviceScreenType);
  }

}

/*
 * 绑定Action与动作
 */
final styleReducer = combineReducers<StyleModel>([
  TypedReducer<StyleModel, SetStyleDataAction>(SetStyleDataAction.setSet),
]);