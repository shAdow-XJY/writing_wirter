import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../state_machine/redux/action/set_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

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

  /// 列表项组件
  List<Widget> createChapterList(List<String> settingsList) {
    List<Widget> settingsListViewItems = [];
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
        debugPrint("store in settings_listview");
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
                color: Theme.of(context).primaryColorDark.withOpacity(0.5),
                border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).dividerColor,
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
