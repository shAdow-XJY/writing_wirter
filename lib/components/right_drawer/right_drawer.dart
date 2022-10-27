import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/right_drawer/set_listview.dart';
import '../../redux/app_state/state.dart';
import '../../server/style/StyleBase.dart';
import '../toast_dialog.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        return {
          'currentBookName': store.state.textModel.currentBook,
          'ioBase': store.state.ioBase,
          'deviceType': store.state.styleModel.deviceScreenType,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Drawer(
          width: MediaQuery.of(context).size.width * StyleBase.getDrawerWidthFactor(map['deviceType']),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(map['currentBookName'] ?? ''),
              leading: IconButton(
                icon: const Icon(Icons.file_open),
                onPressed: () {
                  map['ioBase'].openSettingDirectory(map['currentBookName']);
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ToastDialog(
                        title: '新建设定集',
                        callBack: (strBack) => {
                          if (strBack.isNotEmpty)
                            {
                              map['ioBase']
                                  .createSet(map['currentBookName'], strBack),
                              Navigator.of(context).pop(),
                            },
                        },
                      ),
                    );
                  },
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
