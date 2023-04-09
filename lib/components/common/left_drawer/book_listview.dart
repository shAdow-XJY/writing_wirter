import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:event_bus/event_bus.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../../../state_machine/event_bus/events.dart';
import '../dialog/edit_toast_dialog.dart';
import '../buttons/transparent_icon_button.dart';
import '../toast/global_toast.dart';
import '../toast/toast_widget.dart';
import 'chapter_listview.dart';

class BookListView extends StatefulWidget {
  const BookListView({
    Key? key,
  }) : super(key: key);

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;

  List<String> bookNameList = [];

  @override
  void initState() {
    super.initState();
    bookNameList = ioBase.getAllBooks();
    subscription_1 = eventBus.on<CreateNewBookEvent>().listen((event) {
      setState(() {
        bookNameList = ioBase.getAllBooks();
      });
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: bookNameList.length,
      itemBuilder: (context, index) => BookListViewItem(
        bookName: bookNameList[index],
      ),
    );
  }
}

class BookListViewItem extends StatefulWidget {
  String bookName;

  BookListViewItem({
    Key? key,
    required this.bookName,
  }) : super(key: key);

  @override
  State<BookListViewItem> createState() => _BookListViewItemState();
}

class _BookListViewItemState extends State<BookListViewItem> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;

  /// 列表是否展开
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    /// bus总线：修改后实时更新
    subscription_1 = eventBus.on<RenameBookNameEvent>().listen((event) {
      setState(() {
        widget.bookName;
      });
    });
    subscription_2 = eventBus.on<CreateNewChapterEvent>().listen((event) {
      if (event.bookName.compareTo(widget.bookName) == 0) {
        setState(() {
          widget.bookName;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription_1.cancel();
    subscription_2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        debugPrint("store in book_listview");
        return {};
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Container(
                height: height / 15.0,
                color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            TransIconButton(
                              icon: const Icon(Icons.drive_file_rename_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => EditToastDialog(
                                    init: widget.bookName,
                                    title: '重命名书籍',
                                    callBack: (newBookName) => {
                                      if (newBookName.isNotEmpty) {
                                        ioBase.renameBook(widget.bookName, newBookName),
                                        widget.bookName = newBookName,
                                        eventBus.fire(RenameBookNameEvent()),
                                        Navigator.pop(context),
                                      } else {
                                        GlobalToast.showErrorTop('书籍名字不能为空',),
                                      },
                                    },
                                  ),
                                );
                              },
                            ),
                            Text(
                              widget.bookName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                wordSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                              flex: 1,
                              child: TransIconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditToastDialog(
                                      title: '新建章节',
                                      callBack: (chapterName) => {
                                        if (chapterName.isNotEmpty) {
                                          ioBase.createChapter(widget.bookName, chapterName),
                                          eventBus.fire(CreateNewChapterEvent(widget.bookName)),
                                          Navigator.pop(context),
                                        } else {
                                          GlobalToast.showErrorTop('章节名字不能为空',),
                                        },
                                      },
                                    ),
                                  );
                                },
                              ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(isExpanded
                                ? Icons.arrow_drop_down
                                : Icons.arrow_drop_up),
                          ),
                        ],
                      ),
                    ),
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
                ? ChapterListView(
                    bookName: widget.bookName,
                  )
                : const SizedBox(),
            Divider(
              thickness: 1,
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.6),
            ),
          ],
        );
      },
    );
  }
}
