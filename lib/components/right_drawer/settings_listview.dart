import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../redux/action/set_action.dart';
import '../../redux/app_state/state.dart';

class SettingsListView extends StatefulWidget {
  final String setName;

  const SettingsListView({
    Key? key,
    required this.setName,
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

  List<Widget> createChapterList(List<String> chapterList) {
    settingsListViewItems.clear();
    for (var settingName in chapterList) {
      settingsListViewItems.add(SettingsListViewItem(
        setName: widget.setName,
        settingName: settingName,
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
      builder: (BuildContext context, List<String> chapterList) {
        return Column(
          children: createChapterList(chapterList),
        );
      },
    );
  }
}

class SettingsListViewItem extends StatelessWidget {
  final String setName;
  final String settingName;

  const SettingsListViewItem({
    Key? key,
    required this.setName,
    required this.settingName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store store) {
        return () => {
          store.dispatch(
            SetSetDataAction(currentSet: setName, currentSetting: settingName),
          ),
        };
      },
      builder: (BuildContext context, VoidCallback clickSetting) {
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
                Text(settingName),
              ],
            ),
          ),
          onTap: () {
            clickSetting();
          },
        );
      },
    );
  }
}
