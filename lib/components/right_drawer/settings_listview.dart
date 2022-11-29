import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/unusedNow/parser_action.dart';
import '../../redux/action/set_action.dart';
import '../../redux/app_state/state.dart';
import '../transparent_checkbox.dart';

class SettingsListView extends StatefulWidget {
  final String setName;
  final bool addTextParser;

  const SettingsListView({
    Key? key,
    required this.setName,
    this.addTextParser = false,
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

  List<Widget> createChapterList(List<String> settingsList) {
    settingsListViewItems.clear();
    for (var settingName in settingsList) {
      settingsListViewItems.add(SettingsListViewItem(
        setName: widget.setName,
        settingName: settingName,
        addTextParser: widget.addTextParser,
      ));
    }
    return settingsListViewItems;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store store) {
        return store.state.ioBase.getAllSettings(store.state.textModel.currentBook, widget.setName);
      },
      builder: (BuildContext context, List<String> settingsList) {
        return Column(
          children: createChapterList(settingsList),
        );
      },
    );
  }
}

class SettingsListViewItem extends StatefulWidget {
  final String setName;
  final String settingName;
  bool addTextParser;

  SettingsListViewItem({
    Key? key,
    required this.setName,
    required this.settingName,
    this.addTextParser = false,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TransCheckBox(
                  initBool: widget.addTextParser,
                  onChanged: (bool changedResult) {
                    setState(() {
                      widget.addTextParser = changedResult;
                    });
                  },
                ),
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
