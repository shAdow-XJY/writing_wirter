import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer2/components/toast_dialog.dart';
import 'package:writing_writer2/server/file/IOBase.dart';
import '../redux/app_state/state.dart';
import 'book_listview.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width / 4.0,
        child: StoreConnector<AppState, IOBase>(
          converter: (Store store) {
            return store.state.ioBase;
          },
          builder: (BuildContext context, IOBase ioBase) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Directory'),
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
                          callBack: (strBack) => {
                            if (strBack.isNotEmpty) {
                              ioBase.createBook(strBack),
                              Navigator.of(context).pop(),
                            },
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: const BookListView(),
            );
          },
        ),
    );
  }
}
