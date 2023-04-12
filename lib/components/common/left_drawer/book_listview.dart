import 'dart:async';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';
import '../buttons/transparent_icon_button.dart';
import '../dialog/rename_or_dialog.dart';
import '../toast/global_toast.dart';
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
  late StreamSubscription subscription_2;

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
    subscription_2 = eventBus.on<RemoveBookEvent>().listen((event) {
      setState(() {
        bookNameList.remove(event.bookName);
        bookNameList;
      });
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
  final String bookName;

  const BookListViewItem({
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

  /// 书籍名称
  late String bookName;

  /// 列表是否展开
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    bookName = widget.bookName;

    /// bus总线：修改后实时更新
    subscription_1 = eventBus.on<RenameBookNameEvent>().listen((event) {
      if (event.oldBookName.compareTo(bookName) == 0) {
        setState(() {
          bookName = event.newBookName;
        });
      }
    });
    subscription_2 = eventBus.on<CreateNewChapterEvent>().listen((event) {
      if (event.bookName.compareTo(bookName) == 0) {
        setState(() {
          bookName;
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
      void renameBook(String oldBookName, String newBookName) {
        if (oldBookName.compareTo(store.state.textModel.currentBook) == 0) {
          store.dispatch(SetTextDataAction(
            currentBook: newBookName,
            currentChapter: store.state.textModel.currentChapter,
          ));
        }
      }

      void renameChapter(String bookName, String oldChapterName, String newChapterName) {
        if (bookName.compareTo(store.state.textModel.currentBook) == 0) {
          if (oldChapterName.compareTo(store.state.textModel.currentChapter) ==
              0) {
            store.dispatch(SetTextDataAction(
                currentBook: bookName, currentChapter: newChapterName));
          }
        }
      }

      return {
        "renameBook": renameBook,
        "renameChapter": renameChapter,
      };
    }, builder: (BuildContext context, Map<String, dynamic> storeMap) {
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
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => RenameOrDialog(
                                dialogTitle: '重命名',
                                titleOne: '重命名书籍',
                                titleTwo: '重命名章节',
                                initInputText: bookName,
                                items: ioBase.getAllChapters(bookName),
                                callBack: (RenameDialogMap map) {
                                  if (map.isChooseOne) {
                                    // 重命名书籍
                                    if (map.inputString.isNotEmpty) {
                                      ioBase.renameBook(
                                          bookName, map.inputString);
                                      storeMap["renameBook"](
                                          bookName, map.inputString);
                                      eventBus.fire(RenameBookNameEvent(
                                          oldBookName: bookName,
                                          newBookName: map.inputString));
                                      Navigator.pop(context);
                                    } else {
                                      GlobalToast.showErrorTop('新书籍的名字不能为空');
                                    }
                                  } else {
                                    // 重命名章节
                                    if (map.selectedString.isNotEmpty) {
                                      if (map.inputString.isNotEmpty) {
                                        ioBase.renameChapter(
                                            bookName,
                                            map.selectedString,
                                            map.inputString);
                                        storeMap["renameChapter"](
                                            bookName,
                                            map.selectedString,
                                            map.inputString);
                                        eventBus.fire(RenameChapterNameEvent(
                                            bookName: bookName,
                                            oldChapterName: map.selectedString,
                                            newChapterName: map.inputString));
                                        Navigator.pop(context);
                                      } else {
                                        GlobalToast.showErrorTop('新章节的名字不能为空');
                                      }
                                    } else {
                                      GlobalToast.showErrorTop(
                                          '没有选中要重新命名的旧章节名称');
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        Flexible(
                          child: Text(
                            bookName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.0,
                              wordSpacing: 2.0,
                            ),
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
                                    if (chapterName.isNotEmpty)
                                      {
                                        ioBase.createChapter(
                                            bookName, chapterName),
                                        eventBus.fire(
                                            CreateNewChapterEvent(bookName)),
                                        Navigator.pop(context),
                                      }
                                    else
                                      {
                                        GlobalToast.showErrorTop(
                                          '章节名字不能为空',
                                        ),
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
                  bookName: bookName,
                )
              : const SizedBox(),
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.6),
          ),
        ],
      );
    });
  }
}
