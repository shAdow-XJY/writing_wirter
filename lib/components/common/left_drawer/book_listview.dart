import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:event_bus/event_bus.dart';
import '../../../server/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../../../state_machine/event_bus/events.dart';
import '../toast_dialog.dart';
import '../transparent_icon_button.dart';
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
  final IOBase ioBase = appGetIt<IOBase>();
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt<EventBus>();

  List<String> bookNameList = [];

  @override
  void initState() {
    super.initState();
    bookNameList = ioBase.getAllBooks();
    eventBus.on<CreateNewBookEvent>().listen((event) {
      setState(() {
        bookNameList = ioBase.getAllBooks();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 1,
        height: 1,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
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
  final IOBase ioBase = appGetIt<IOBase>();
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt<EventBus>();

  /// 列表是否展开
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    /// bus总线：修改后实时更新
    eventBus.on<RenameBookNameEvent>().listen((event) {
      setState(() {
        widget.bookName;
      });
    });
    eventBus.on<CreateNewChapterEvent>().listen((event) {
      if (event.bookName.compareTo(widget.bookName) == 0) {
        setState(() {
          widget.bookName;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        return {};
      },
      builder: (BuildContext context, Map<String, dynamic> map) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: SizedBox(
                height: height / 15.0,
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
                                  builder: (context) => ToastDialog(
                                    init: widget.bookName,
                                    title: '重命名书籍',
                                    callBack: (newBookName) => {
                                      if (newBookName.isNotEmpty) {
                                        ioBase.renameBook(widget.bookName, newBookName),
                                        widget.bookName = newBookName,
                                        eventBus.fire(RenameBookNameEvent()),
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
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TransIconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ToastDialog(
                                  title: '新建章节',
                                  callBack: (chapterName) => {
                                    if (chapterName.isNotEmpty) {
                                      ioBase.createChapter(widget.bookName, chapterName),
                                      eventBus.fire(CreateNewChapterEvent(widget.bookName)),
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
          ],
        );
      },
    );
  }
}
