import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/right_drawer/settings_listview.dart';
import 'package:writing_writer/state_machine/redux/action/set_action.dart';
import '../../../service/file/IOBase.dart';
import '../../../service/parser/Parser.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/parser_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';
import '../dialog/rename_or_dialog.dart';
import '../vertical_expand_animated_widget.dart';
import '../toast/global_toast.dart';
import '../transparent_checkbox.dart';
import '../buttons/transparent_icon_button.dart';

class SetListView extends StatefulWidget {
  const SetListView({
    Key? key,
  }) : super(key: key);

  @override
  State<SetListView> createState() => _SetListViewState();
}

class _SetListViewState extends State<SetListView> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;

  /// 书籍名称
  String currentBook = '';
  Map<String, dynamic> setJson = {};

  @override
  void initState() {
    super.initState();
    subscription_1 = eventBus.on<CreateNewSetEvent>().listen((event) {
      setState(() {
        setJson.clear();
        setJson.addAll(ioBase.getBookSetJsonContent(currentBook));
      });
    });
    subscription_2 = eventBus.on<RemoveSetEvent>().listen((event) {
      setState(() {
        setJson["setList"].remove(event.setName);
        setJson.remove(event.setName);
      });
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    subscription_2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store store) {
        debugPrint("store in SetListView");
        currentBook = store.state.textModel.currentBook;
        setJson = ioBase.getBookSetJsonContent(currentBook);
        return () => {};
      },
      builder: (BuildContext context, VoidCallback voidCallback) {
        return ListView.builder(
          controller: ScrollController(),
          itemCount: setJson["setList"].length,
          itemBuilder: (context, index) => SetListViewItem(
              setName: setJson["setList"][index],
              isParsed: setJson[setJson["setList"][index]]["isParsed"],
          ),
        );
      },
    );
  }
}

class SetListViewItem extends StatefulWidget {
  final String setName;
  final bool isParsed;

  const SetListViewItem({
    Key? key,
    required this.setName,
    required this.isParsed,
  }) : super(key: key);

  @override
  State<SetListViewItem> createState() => _SetListViewItemState();
}

class _SetListViewItemState extends State<SetListViewItem> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;
  late StreamSubscription subscription_3;
  late StreamSubscription subscription_4;

  /// 设定集名称
  late String setName;
  /// 设定集是否加入文本解析
  late bool addTextParser;
  /// 列表展开
  bool isExpanded = false;

  /// 设定列表
  List<String> settingsList = [];
  /// 当前的书籍
  String currentBook = '';
  /// 被解析的对象构造
  Map<String, Set<String>> newParserObj = {};

  @override
  void initState() {
    super.initState();
    setName = widget.setName;
    addTextParser = widget.isParsed;
    subscription_1 = eventBus.on<RenameSetEvent>().listen((event) {
      if (event.oldSetName.compareTo(setName) == 0){
        setState(() {
          setName = event.newSetName;
        });
      }
    });
    subscription_2 = eventBus.on<CreateNewSettingEvent>().listen((event) {
      if (event.setName.compareTo(setName) == 0){
        setState(() {
          settingsList = ioBase.getAllSettings(currentBook, setName);
        });
      }
    });
    subscription_3 = eventBus.on<RemoveSettingEvent>().listen((event) {
      if (event.setName.compareTo(setName) == 0){
        setState(() {
          settingsList.remove(event.settingName);
        });
      }
    });
    subscription_4 = eventBus.on<RenameSettingEvent>().listen((event) {
      if (event.setName.compareTo(setName) == 0) {
        setState(() {
          settingsList[settingsList.indexOf(event.oldSettingName)] = event.newSettingName;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    subscription_2.cancel();
    subscription_3.cancel();
    subscription_4.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint('store in set_listview');
        currentBook = store.state.textModel.currentBook;
        settingsList = ioBase.getAllSettings(currentBook, setName);
        newParserObj = {};
        if (addTextParser) {
          newParserObj = Parser.addSetToParser(store.state.parserModel.parserObj, setName, settingsList);
        } else {
          newParserObj = Parser.removeSetFromParser(store.state.parserModel.parserObj, setName);
        }
        if (!Parser.compareParser(newParserObj, store.state.parserModel.parserObj)) {
          store.dispatch(SetParserDataAction(parserObj: newParserObj));
        }
        /// 重命名设定集
        void renameSet(String oldSetName, String newSetName) {
          if (oldSetName.compareTo(store.state.setModel.currentSet) == 0) {
            setName = newSetName;
            store.dispatch(SetSetDataAction(currentSet: newSetName, currentSetting: store.state.setModel.currentSetting));
          }
          if (addTextParser) {
            newParserObj = Parser.replaceSetInParser(store.state.parserModel.parserObj, oldSetName, newSetName);
            store.dispatch(SetParserDataAction(parserObj: newParserObj));
          }
        }
        /// 重命名设定
        void renameSetting(String oldSettingName, String newSettingName) {
          if (setName.compareTo(store.state.setModel.currentSet) == 0 && oldSettingName.compareTo(store.state.setModel.currentSetting) == 0) {
            store.dispatch(SetSetDataAction(currentSet: setName, currentSetting: newSettingName));
          }
          if (addTextParser) {
            newParserObj = Parser.replaceSettingInParser(store.state.parserModel.parserObj, setName, oldSettingName, newSettingName);
            store.dispatch(SetParserDataAction(parserObj: newParserObj));
          }
        }
        return {
          "renameSet": renameSet,
          "renameSetting": renameSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> storeMap) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Container(
                height: height / 15.0,
                color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          TransIconButton(
                            icon: const Icon(Icons.drive_file_rename_outline),
                            onPressed: () {
                              List<String> setList = ioBase.getAllSets(currentBook);
                              showDialog(
                                context: context,
                                builder: (context) => RenameOrDialog(
                                  dialogTitle: '重命名',
                                  titleOne: '重命名设定集',
                                  titleTwo: '重命名设定',
                                  initInputText: setName,
                                  items: settingsList,
                                  callBack: (RenameDialogMap map) {
                                    if (map.isChooseOne) {
                                      // 重命名设定集
                                      if (map.inputString.isNotEmpty) {
                                        if (setName.compareTo(map.inputString) == 0) {
                                          // 设定集名字没有改动
                                          Navigator.pop(context);
                                        } else if (!setList.contains(map.inputString)) {
                                          ioBase.renameSet(currentBook, setName, map.inputString);
                                          storeMap["renameSet"](setName, map.inputString);
                                          eventBus.fire(RenameSetEvent(oldSetName: setName, newSetName: map.inputString));
                                          Navigator.pop(context);
                                        } else {
                                          GlobalToast.showErrorTop('该书下已存在该设定集名，请更改另一个名称');
                                        }
                                      } else {
                                        GlobalToast.showErrorTop('新设定集的名字不能为空');
                                      }
                                    } else {
                                      // 重命名设定
                                      if (map.selectedString.isNotEmpty) {
                                        if (map.inputString.isNotEmpty) {
                                          if (map.selectedString.compareTo(map.inputString) == 0) {
                                            // 设定名字没有改动
                                            Navigator.pop(context);
                                          } else if (!settingsList.contains(map.inputString)) {
                                            ioBase.renameSetting(currentBook, setName, map.selectedString, map.inputString);
                                            storeMap["renameSetting"](map.selectedString, map.inputString);
                                            eventBus.fire(RenameSettingEvent(setName: setName, oldSettingName: map.selectedString, newSettingName: map.inputString));
                                            Navigator.pop(context);
                                          } else {
                                            GlobalToast.showErrorTop('该设定集下已存在该设定名，请更改另一个名称');
                                          }
                                        } else {
                                          GlobalToast.showErrorTop('新设定的名字不能为空');
                                        }
                                      } else {
                                        GlobalToast.showErrorTop('没有选中要重新命名的旧设定名称');
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          Text(
                            widget.setName,
                            style: const TextStyle(
                              fontSize: 16.0,
                              wordSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 1,
                              child: TransCheckBox(
                                initBool: addTextParser,
                                onChanged: (bool changedResult) {
                                  setState(() {
                                    addTextParser = changedResult;
                                    ioBase.changeParserOfBookSetJson(currentBook, setName, addTextParser);
                                  });
                                },
                              ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TransIconButton(
                              icon: const Icon(Icons.add),
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditToastDialog(
                                    title: '新建设定',
                                    callBack: (settingName) => {
                                      if (settingName.isNotEmpty) {
                                        if (!settingsList.contains(settingName)) {
                                          ioBase.createSetting(currentBook, setName, settingName),
                                          eventBus.fire(CreateNewSettingEvent(setName: setName, settingName: settingName)),
                                          Navigator.pop(context),
                                        } else {
                                          GlobalToast.showErrorTop('该设定集下已存在该设定名，请更改另一个名称',),
                                        }
                                      } else {
                                        GlobalToast.showErrorTop('设定名字不能为空',),
                                      },
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(isExpanded
                                ? Icons.arrow_drop_down
                                : Icons.arrow_drop_up),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            VerticalExpandAnimatedWidget(
              isExpanded: isExpanded,
              child: SettingsListView(setName: setName, settingsList: settingsList,)
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.6),
            ),
          ],
        );
      },
    );
  }
}
