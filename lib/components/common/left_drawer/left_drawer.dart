import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';
import '../dialog/edit_toast_dialog.dart';
import '../dialog/remove_or_dialog.dart';
import '../toast/global_toast.dart';
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
    widthFactor = widget.widthFactor ?? widthFactor;
    if (widthFactor < 0.0 || widthFactor > 1.0) {
      widthFactor = 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
      converter: (Store store) {
        void removeBook(String bookName) {
          if (bookName.compareTo(store.state.textModel.currentBook) == 0) {
            store.dispatch(SetTextDataAction(currentBook: '', currentChapter: '',));
          }
        }

        void removeChapter(String bookName, String chapterName) {
          if (bookName.compareTo(store.state.textModel.currentBook) == 0) {
            if (chapterName.compareTo(store.state.textModel.currentChapter) == 0) {
              store.dispatch(SetTextDataAction(currentBook: bookName, currentChapter: ''));
            }
          }
        }

        return {
          "removeBook": removeBook,
          "removeChapter": removeChapter,
        };
      },
      builder: (BuildContext context, Map<String, dynamic> storeMap) {
        return Drawer(
            width: MediaQuery.of(context).size.width * widthFactor,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('目录'),
                leading: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => RemoveOrDialog(
                        dialogTitle: '删除',
                        titleOne: '删除书籍',
                        titleTwo: '删除章节',
                        hintTextOne: '请选择一本书',
                        hintTextTwo: '请选择一章节',
                        itemsOne: ioBase.getAllBooks(),
                        getItemsTwo: (String selectedBookName) {
                          return ioBase.getAllChapters(selectedBookName);
                        },
                        callBack: (RemoveDialogMap map) {
                          if (map.isChooseOne) {
                            // 删除书籍
                            if (map.selectedOne.isNotEmpty) {
                              ioBase.removeBook(map.selectedOne);
                              storeMap["removeBook"](map.selectedOne);
                              eventBus.fire(RemoveBookEvent(bookName: map.selectedOne));
                              Navigator.pop(context);
                            } else {
                              GlobalToast.showErrorTop('没有选择删除的书籍');
                            }
                          } else {
                            // 删除章节
                            if (map.selectedOne.isNotEmpty) {
                              if (map.selectedTwo.isNotEmpty) {
                                ioBase.removeChapter(map.selectedOne, map.selectedTwo);
                                storeMap["removeChapter"](map.selectedOne, map.selectedTwo);
                                eventBus.fire(RemoveChapterEvent(bookName: map.selectedOne, chapterName: map.selectedTwo));
                                Navigator.pop(context);
                              } else {
                                GlobalToast.showErrorTop('没有选择删除的章节');
                              }
                            } else {
                              GlobalToast.showErrorTop('没有选择指定书籍');
                            }
                          }
                          // if (map.isChooseOne) {
                          //   // 重命名书籍
                          //   if (map.inputString.isNotEmpty) {
                          //     ioBase.renameBook(bookName, map.inputString);
                          //     storeMap["renameBook"](bookName, map.inputString);
                          //     eventBus.fire(RenameBookNameEvent(oldBookName: bookName, newBookName: map.inputString));
                          //     Navigator.pop(context);
                          //   } else {
                          //     GlobalToast.showErrorTop('新书籍的名字不能为空');
                          //   }
                          // } else {
                          //   // 重命名章节
                          //   if (map.selectedString.isNotEmpty) {
                          //     if (map.inputString.isNotEmpty) {
                          //       ioBase.renameChapter(bookName, map.selectedString, map.inputString);
                          //       storeMap["renameChapter"](bookName, map.selectedString, map.inputString);
                          //       eventBus.fire(RenameChapterNameEvent(bookName: bookName, oldChapterName: map.selectedString, newChapterName: map.inputString));
                          //       Navigator.pop(context);
                          //     } else {
                          //       GlobalToast.showErrorTop('新章节的名字不能为空');
                          //     }
                          //   } else {
                          //     GlobalToast.showErrorTop('没有选中要重新命名的旧章节名称');
                          //   }
                          // }
                        },
                      ),
                    );
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
                            if (bookName.isNotEmpty)
                              {
                                ioBase.createBook(bookName),
                                eventBus.fire(CreateNewBookEvent()),
                                Navigator.pop(context),
                              }
                            else
                              {
                                GlobalToast.showErrorTop(
                                  '书籍名字不能为空',
                                ),
                              },
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: const BookListView(),
            ));
      },
    );
  }
}
