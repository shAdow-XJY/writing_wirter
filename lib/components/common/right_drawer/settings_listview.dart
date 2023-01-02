import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../redux/action/set_action.dart';
import '../../../redux/app_state/state.dart';

class SettingsListView extends StatefulWidget {
  final String setName;
  final List<String> settingsList;

  const SettingsListView({
    Key? key,
    required this.setName,
    required this.settingsList,
  }) : super(key: key);

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  List<Widget> settingsListViewItems = [];

  @override
  void initState() {
    super.initState();
  }

  /// 列表项组件
  List<Widget> createChapterList(List<String> settingsList) {
    settingsListViewItems.clear();
    for (var settingName in settingsList) {
      settingsListViewItems.add(SettingsListViewItem(
        setName: widget.setName,
        settingName: settingName,
      ));
    }
    return settingsListViewItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: createChapterList(widget.settingsList),
    );
  }
}

class SettingsListViewItem extends StatefulWidget {
  final String setName;
  final String settingName;

  const SettingsListViewItem({
    Key? key,
    required this.setName,
    required this.settingName,
  }) : super(key: key);

  @override
  State<SettingsListViewItem> createState() => _SettingsListViewItemState();
}

class _SettingsListViewItemState extends State<SettingsListViewItem> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        void clickSetting() {
          store.dispatch(SetSetDataAction(currentSet: widget.setName, currentSetting: widget.settingName));
        }
        return {
          "clickSetting": clickSetting,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return InkWell(
          child: Container(
            height: height / 18.0,
            decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
                border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.settingName),
              ],
            ),
          ),
          onTap: () {
            map["clickSetting"]();
          },
        );
      },
    );
  }
}
