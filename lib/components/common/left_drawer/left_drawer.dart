import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/server/style/StyleBase.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        return {
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
                title: const Text('目录'),
                leading: IconButton(
                  icon: const Icon(Icons.file_open),
                  onPressed: () {
                    map['ioBase'].openRootDirectory();
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
                              map['ioBase'].createBook(strBack),
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
            )
        );
      },
    );
  }
}
