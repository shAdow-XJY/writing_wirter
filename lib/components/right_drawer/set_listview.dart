import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/right_drawer/settings_listview.dart';
import '../../redux/app_state/state.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store store) {
        return store.state.ioBase.getAllSet(store.state.textModel.currentBook);
      },
      builder: (BuildContext context, List<String> setNameList) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          controller: ScrollController(),
          itemCount: setNameList.length,
          itemBuilder: (context, index) => SetListViewItem(
            setName: setNameList[index],
          ),
        );
      },
    );
  }
}

class SetListViewItem extends StatefulWidget {
  final String setName;

  const SetListViewItem({
    Key? key,
    required this.setName,
  }) : super(key: key);

  @override
  State<SetListViewItem> createState() => _SetListViewItemState();
}

class _SetListViewItemState extends State<SetListViewItem> {
  /// 列表展开
  bool isExpanded = false;
  /// 设定集是否加入文本解析
  bool addTextParser = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        void renameSet(String oldSetName, String newSetName) => {
          store.state.ioBase.renameSet(store.state.textModel.currentBook, oldSetName, newSetName),
        };
        void createSetting(String settingName) => {
          store.state.ioBase.createSetting(store.state.textModel.currentBook, widget.setName, settingName),
        };
        return {
          "renameSet": renameSet,
          "createSetting": createSetting,
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
                                  callBack: (strBack) => {
                                    if (strBack.isNotEmpty) {
                                      map["renameSet"](widget.setName, strBack),
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
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TransCheckBox(
                            initBool: addTextParser,
                            onChanged: (bool changedResult) {
                              setState(() {
                                addTextParser = changedResult;
                              });
                            },
                          ),
                          TransIconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ToastDialog(
                                  title: '新建设定',
                                  callBack: (strBack) => {
                                    if (strBack.isNotEmpty) {
                                      map["createSetting"](strBack),
                                    },
                                  },
                                ),
                              );
                            },
                          ),
                          Icon(isExpanded
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up),
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
                    addTextParser: addTextParser,
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
