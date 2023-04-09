import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../dialog/edit_toast_dialog.dart';
import '../toast/global_toast.dart';
import '../toast/toast_widget.dart';
import 'book_listview.dart';

class LeftDrawer extends StatefulWidget {
  final double? widthFactor;
  const LeftDrawer({
    Key? key,
    this.widthFactor,
  }) : super(key: key);

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
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
    return Drawer(
        width: MediaQuery.of(context).size.width * widthFactor,
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
                    builder: (context) => EditToastDialog(
                      title: '新建书籍',
                      callBack: (bookName) => {
                        if (bookName.isNotEmpty) {
                          ioBase.createBook(bookName),
                          eventBus.fire(CreateNewBookEvent()),
                          Navigator.pop(context),
                        } else {
                          GlobalToast.show(
                            '书籍名字不能为空',
                            type: ToastType.error,
                            position: ToastPosition.top,
                          ),
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
  }
}
