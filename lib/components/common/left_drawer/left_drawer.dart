import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/server/style/StyleBase.dart';
import '../../../server/file/IOBase.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../toast_dialog.dart';
import 'book_listview.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt<IOBase>();
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt<EventBus>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint("store in left_drawer");
        return {
          'deviceType': store.state.styleModel.deviceScreenType,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Drawer(
            width: MediaQuery.of(context).size.width * StyleBase.getDrawerWidthFactor(map['deviceType']),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('目录'),
                leading: IconButton(
                  icon: const Icon(Icons.file_open),
                  onPressed: () {
                    ioBase.openRootDirectory();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ToastDialog(
                          title: '新建书籍',
                          callBack: (bookName) => {
                            if (bookName.isNotEmpty) {
                              ioBase.createBook(bookName),
                              eventBus.fire(CreateNewBookEvent()),
                            },
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              /// 不加const ，setStateful 可以刷新到
              body: const BookListView(),
            )
        );
      },
    );
  }
}
