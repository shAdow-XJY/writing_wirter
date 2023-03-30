import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/components/common/right_drawer/set_listview.dart';
import 'package:writing_writer/state_machine/event_bus/events.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';

class RightDrawer extends StatefulWidget {
  final double? widthFactor;
  const RightDrawer({
    Key? key,
    this.widthFactor,
  }) : super(key: key);

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");

  /// 抽屉的宽度因子
  double widthFactor = 0.9;

  @override
  void initState() {
    super.initState();
    widthFactor = widget.widthFactor??widthFactor;
    if (widthFactor < 0.0 || widthFactor > 1.0) {
      widthFactor = 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint("store in right_drawer");
        return {
          'currentBookName': store.state.textModel.currentBook,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Drawer(
            width: MediaQuery.of(context).size.width * widthFactor,
            child: map['currentBookName'].toString().isEmpty
                ? Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: const Text('no book selected'),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: Text(map['currentBookName']),
                      leading: IconButton(
                        icon: const Icon(Icons.file_open),
                        onPressed: () {
                          ioBase.openSettingDirectory(map['currentBookName']);
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
                                  builder: (context) => EditToastDialog(
                                    title: '新建设定集',
                                    callBack: (setName) => {
                                      if (setName.isNotEmpty)
                                        {
                                          ioBase.createSet(
                                              map['currentBookName'], setName),
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
                    ),
                    body: const SetListView(),
                  ),
        );
      },
    );
  }
}
