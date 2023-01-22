import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/right_drawer/set_listview.dart';
import 'package:writing_writer/state_machine/event_bus/events.dart';
import '../../../server/style/StyleBase.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../toast_dialog.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  /// 事件总线
  EventBus eventBus = EventBus();

  @override
  void initState() {
    super.initState();
    eventBus.on<CreateNewSetEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    eventBus.destroy();
    super.dispose();
  }

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
            appBar: map['currentBookName'].toString().isNotEmpty
                ?
            AppBar(
              centerTitle: true,
              title: Text(map['currentBookName'] ?? ''),
              leading: IconButton(
                icon: const Icon(Icons.file_open),
                onPressed: () {
                  map['ioBase'].openSettingDirectory(map['currentBookName']);
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
                          builder: (context) => ToastDialog(
                            title: '新建设定集',
                            callBack: (setName) => {
                              if (setName.isNotEmpty)
                                {
                                  map['ioBase'].createSet(map['currentBookName'], setName),
                                  eventBus.fire(CreateNewSetEvent()),
                                },
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
                :
            AppBar(
              centerTitle: true,
              title: const Text('no book selected'),
            ),
            /// 不加const，用于刷新
            body: SetListView(),
          ),
        );
      },
    );
  }
}
