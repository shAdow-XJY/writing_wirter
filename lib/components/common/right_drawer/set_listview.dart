import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/right_drawer/settings_listview.dart';
import '../../../service/file/IOBase.dart';
import '../../../service/parser/Parser.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/parser_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../toast_dialog.dart';
import '../transparent_checkbox.dart';
import '../transparent_icon_button.dart';

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

  @override
  void initState() {
    super.initState();
    subscription_1 = eventBus.on<CreateNewSetEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (Store store) {
        return ioBase.getAllSetMap(store.state.textModel.currentBook)["setList"];
      },
      builder: (BuildContext context, List<dynamic> setList) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          controller: ScrollController(),
          itemCount: setList.length,
          itemBuilder: (context, index) => SetListViewItem(
              setName: setList[index]["setName"],
              addToParser: setList[index]["addToParser"],
          ),
        );
      },
    );
  }
}

class SetListViewItem extends StatefulWidget {
  String setName;
  final bool addToParser;

  SetListViewItem({
    Key? key,
    required this.setName,
    required this.addToParser,
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

  /// 设定集是否加入文本解析
  bool addTextParser = false;
  /// 列表展开
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    addTextParser = widget.addToParser;
    subscription_1 = eventBus.on<RenameSetEvent>().listen((event) {
      setState(() {
        widget.setName;
      });
    });
    subscription_2 = eventBus.on<CreateNewSettingEvent>().listen((event) {
      setState(() {
        widget.setName;
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
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint('store in set_listview');
        List<String> settingsList = ioBase.getAllSettings(store.state.textModel.currentBook, widget.setName);
        Map<String, Set<String>> newParserModel = {};
        if (addTextParser) {
          newParserModel = Parser.addSetToParser(store.state.parserModel.parserObj, widget.setName, settingsList);
        } else {
          newParserModel = Parser.removeSetFromParser(store.state.parserModel.parserObj, widget.setName);
        }
        if (!Parser.compareParser(newParserModel, store.state.parserModel.parserObj)) {
          store.dispatch(SetParserDataAction(parserObj: newParserModel));
        }
        /// 重命名设定集
        void renameSet(String oldSetName, String newSetName) => {
          ioBase.renameSet(store.state.textModel.currentBook, oldSetName, newSetName),
        };
        /// 新建设定
        void createSetting(String settingName) => {
          ioBase.createSetting(store.state.textModel.currentBook, widget.setName, settingName),
        };
        /// 修改设定集是否加入解析
        void changeParserOfBookSetJson(bool addToParser) {
          ioBase.changeParserOfBookSetJson(store.state.textModel.currentBook, widget.setName, addToParser);
        }
        return {
          "settingsList": settingsList,
          "renameSet": renameSet,
          "createSetting": createSetting,
          "changeParserOfBookSetJson": changeParserOfBookSetJson,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: SizedBox(
                height: height / 15.0,
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
                              showDialog(
                                context: context,
                                builder: (context) => ToastDialog(
                                  init: widget.setName,
                                  title: '重命名设定类',
                                  callBack: (newSetName) => {
                                    if (newSetName.isNotEmpty) {
                                      map["renameSet"](widget.setName, newSetName),
                                      widget.setName = newSetName,
                                      eventBus.fire(RenameSetEvent()),
                                    },
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
                                    map["changeParserOfBookSetJson"](addTextParser);
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
                                  builder: (context) => ToastDialog(
                                    title: '新建设定',
                                    callBack: (settingName) => {
                                      if (settingName.isNotEmpty) {
                                        map["createSetting"](settingName),
                                        eventBus.fire(CreateNewSettingEvent()),
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
            isExpanded
                ? SettingsListView(
                    setName: widget.setName,
                    settingsList: map["settingsList"],
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
