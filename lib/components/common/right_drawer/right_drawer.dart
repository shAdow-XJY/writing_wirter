import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/right_drawer/set_listview.dart';
import 'package:writing_writer/service/parser/Parser.dart';
import 'package:writing_writer/state_machine/event_bus/events.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/parser_action.dart';
import '../../../state_machine/redux/action/set_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';
import '../dialog/remove_or_dialog.dart';
import '../toast/global_toast.dart';

class RightDrawer extends StatefulWidget {
  final double? widthFactor;
  const RightDrawer({
    Key? key,
    this.widthFactor,
  }) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");

  /// 抽屉的宽度因子
  double widthFactor = 0.9;

  /// 当前书籍
  String currentBook = '';

  @override
  void initState() {
    super.initState();
    widthFactor = widget.widthFactor??widthFactor;
    if (widthFactor < 0.0 || widthFactor > 1.0) {
      widthFactor = 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>> (
      converter: (Store store) {
        debugPrint("store in right_drawer");
        currentBook = store.state.textModel.currentBook;
        void removeSet(String setName) {
          if (setName.compareTo(store.state.setModel.currentSet) == 0) {
            store.dispatch(SetSetDataAction(currentSet: '', currentSetting: ''));
          }
          Map<String, Set<String>> parserObj = Parser.deepClone(store.state.parserModel.parserObj);
          if (parserObj.containsKey(setName)) {
            parserObj.remove(setName);
            store.dispatch(SetParserDataAction(parserObj: parserObj));
          }
        }
        void removeSetting(String setName, String settingName) {
          if (setName.compareTo(store.state.setModel.currentSet) == 0
              && settingName.compareTo(store.state.setModel.currentSetting) == 0
          ) {
            store.dispatch(SetSetDataAction(currentSet: '', currentSetting: ''));
          }
          Map<String, Set<String>> parserObj = Parser.deepClone(store.state.parserModel.parserObj);
          if (parserObj.containsKey(setName)) {
            parserObj[setName]?.remove(settingName);
            store.dispatch(SetParserDataAction(parserObj: parserObj));
          }
        }
        return {
          'removeSet': removeSet,
          'removeSetting': removeSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> storeMap) {
        return Drawer(
            width: MediaQuery.of(context).size.width * widthFactor,
            child: currentBook.isEmpty
                ? Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: const Text('no book selected'),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(currentBook),
                      leading: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => RemoveOrDialog(
                              dialogTitle: '删除',
                              titleOne: '删除设定集',
                              titleTwo: '删除指定设定',
                              hintTextOne: '请选择设定集',
                              hintTextTwo: '请选择一个设定',
                              itemsOne: ioBase.getAllSets(currentBook),
                              getItemsTwo: (String selectedSetName) {
                                return ioBase.getAllSettings(currentBook, selectedSetName);
                              },
                              callBack: (RemoveDialogMap map) {
                                if (map.isChooseOne) {
                                  // 删除设定集
                                  if (map.selectedOne.isNotEmpty) {
                                    ioBase.removeSet(currentBook, map.selectedOne);
                                    storeMap["removeSet"](map.selectedOne);
                                    eventBus.fire(RemoveSetEvent(setName: map.selectedOne));
                                    Navigator.pop(context);
                                  } else {
                                    GlobalToast.showErrorTop('没有选择删除的设定集');
                                  }
                                } else {
                                  // 删除设定
                                  if (map.selectedOne.isNotEmpty) {
                                    if (map.selectedTwo.isNotEmpty) {
                                      ioBase.removeSetting(currentBook, map.selectedOne, map.selectedTwo);
                                      storeMap["removeSetting"](map.selectedOne, map.selectedTwo);
                                      eventBus.fire(RemoveSettingEvent(setName: map.selectedOne, settingName: map.selectedTwo));
                                      Navigator.pop(context);
                                    } else {
                                      GlobalToast.showErrorTop('没有选择删除的设定');
                                    }
                                  } else {
                                    GlobalToast.showErrorTop('没有选择指定设定集');
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditToastDialog(
                                    title: '新建设定集',
                                    callBack: (setName) => {
                                      if (setName.isNotEmpty)
                                      {
                                        ioBase.createSet(currentBook, setName),
                                        eventBus.fire(CreateNewSetEvent()),
                                        Navigator.pop(context),
                                      } else {
                                        GlobalToast.showErrorTop('设定集名字不能为空',),
                                      },
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    body: const SetListView(),
                  ),
        );
      },
    );
  }
}
