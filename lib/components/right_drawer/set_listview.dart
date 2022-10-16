import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer2/components/right_drawer/settings_listview.dart';
import 'package:writing_writer2/components/toast_dialog.dart';
import 'package:writing_writer2/components/transparent_icon_button.dart';
import '../../redux/app_state/state.dart';

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
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Function(String)>(
      converter: (Store store) {
        return (String settingName) => {
              store.state.ioBase.createSetting(store.state.textModel.currentBook, widget.setName, settingName),
        };
      },
      builder: (BuildContext context, Function(String) createSetting) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: SizedBox(
                height: height / 15.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.setName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          wordSpacing: 2.0,
                        ),
                      ),
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
                                createSetting(strBack),
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
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            isExpanded
                ? SettingsListView(
                    setName: widget.setName,
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
