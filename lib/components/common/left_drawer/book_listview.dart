import 'dart:async';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/state_machine/redux/action/set_action.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/redux/action/parser_action.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';
import '../buttons/transparent_icon_button.dart';
import '../dialog/rename_or_dialog.dart';
import '../toast/global_toast.dart';
import '../animated//vertical_expand_animated_widget.dart';
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
      itemBuilder: (context, index) {
        final bookName = bookNameList[index];
        return BookListViewItem(
          key: Key(bookName), // 使用唯一的Key标识每个列表项
          bookName: bookName,
        );
      },
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
  }

  @override
  void dispose() {
    subscription_1.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Map<String, dynamic>>(
        converter: (Store store) {
      debugPrint("store in BookListViewItem");
      void renameBook(String oldBookName, String newBookName) {
        if (oldBookName.compareTo(store.state.textModel.currentBook) == 0) {
          bookName = newBookName;
          Map<String, Set<String>> parserObj = store.state.parserModel.parserObj;
          String currentSet = store.state.setModel.currentSet;
          String currentSetting = store.state.setModel.currentSetting;
          store.dispatch(SetTextDataAction(
            currentBook: newBookName,
            currentChapter: store.state.textModel.currentChapter,
          ));
          store.dispatch(SetSetDataAction(
            currentSet: currentSet,
            currentSetting: currentSetting,
          ));
          store.dispatch(SetParserDataAction(parserObj: parserObj));
        }
      }

      void renameChapter(
          String bookName, String oldChapterName, String newChapterName) {
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
                            List<String> bookList = ioBase.getAllBooks();
                            List<String> chapterList = ioBase.getAllChapters(bookName);
                            showDialog(
                              context: context,
                              builder: (context) => RenameOrDialog(
                                dialogTitle: '重命名',
                                titleOne: '重命名书籍',
                                titleTwo: '重命名章节',
                                initInputText: bookName,
                                items: chapterList,
                                callBack: (RenameDialogMap map) {
                                  if (map.isChooseOne) {
                                    // 重命名书籍
                                    if (map.inputString.isNotEmpty) {
                                      if (bookName.compareTo(map.inputString) == 0) {
                                        // 书名没有修改
                                        Navigator.pop(context);
                                      } else if (!bookList.contains(map.inputString)) {
                                        // 不存在该书名的书籍
                                        ioBase.renameBook(bookName, map.inputString);
                                        storeMap["renameBook"](bookName, map.inputString);
                                        eventBus.fire(RenameBookNameEvent(oldBookName: bookName, newBookName: map.inputString));
                                        Navigator.pop(context);
                                      } else {
                                        GlobalToast.showErrorTop('已存在该书名，请更改另一个名称');
                                      }
                                    } else {
                                      GlobalToast.showErrorTop('新书籍的名字不能为空');
                                    }
                                  } else {
                                    // 重命名章节
                                    if (map.selectedString.isNotEmpty) {
                                      if (map.inputString.isNotEmpty) {
                                        if (map.selectedString.compareTo(map.inputString) == 0) {
                                          // 章节名没有修改
                                          Navigator.pop(context);
                                        } else if (!chapterList.contains(map.inputString)) {
                                          // 不存在该章节名的章节
                                          ioBase.renameChapter(bookName, map.selectedString, map.inputString);
                                          storeMap["renameChapter"](bookName, map.selectedString, map.inputString);
                                          eventBus.fire(RenameChapterNameEvent(bookName: bookName, oldChapterName: map.selectedString, newChapterName: map.inputString));
                                          Navigator.pop(context);
                                        } else {
                                          GlobalToast.showErrorTop('该书下已存在该章节名，请更改另一个名称');
                                        }
                                      } else {
                                        GlobalToast.showErrorTop('新章节的名字不能为空');
                                      }
                                    } else {
                                      GlobalToast.showErrorTop('没有选中要重新命名的旧章节名称');
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
                              List<String> chapterList = ioBase.getAllChapters(bookName);
                              showDialog(
                                context: context,
                                builder: (context) => EditToastDialog(
                                  title: '新建章节',
                                  callBack: (chapterName) => {
                                    if (chapterName.isNotEmpty) {
                                      if (!chapterList.contains(chapterName)) {
                                        ioBase.createChapter(bookName, chapterName),
                                        eventBus.fire(CreateNewChapterEvent(bookName: bookName, chapterName: chapterName)),
                                        Navigator.pop(context),
                                      } else {
                                        GlobalToast.showErrorTop('该书下已存在该章节名，请更改另一个名称'),
                                      }
                                    } else {
                                      GlobalToast.showErrorTop('章节名字不能为空'),
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
          VerticalExpandAnimatedWidget(
            isExpanded: isExpanded,
            child: ChapterListView(bookName: bookName,),
          ),
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
