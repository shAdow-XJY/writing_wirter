import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/service/parser/Parser.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/event_bus/events.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/parser_action.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

class ChapterListView extends StatefulWidget {
  final String bookName;

  const ChapterListView({
    Key? key,
    required this.bookName,
  }) : super(key: key);

  @override
  State<ChapterListView> createState() => _ChapterListViewState();
}

class _ChapterListViewState extends State<ChapterListView> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;

  List<String> chapterList = [];

  @override
  void initState() {
    super.initState();
    chapterList = ioBase.getAllChapters(widget.bookName);
    subscription_1  = eventBus.on<RenameChapterNameEvent>().listen((event) {
      if (event.bookName.compareTo(widget.bookName) == 0) {
        setState(() {
          chapterList[chapterList.indexOf(event.oldChapterName)] = event.newChapterName;
        });
      }
    });
    subscription_2  = eventBus.on<RemoveChapterEvent>().listen((event) {
      if (event.bookName.compareTo(widget.bookName) == 0) {
        setState(() {
          chapterList.remove(event.chapterName);
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

  List<Widget> createChapterList(List<String> chapterList) {
    List<Widget> chapterListViewItems = [];
    for (var index = 0; index < chapterList.length; ++index) {
      chapterListViewItems.add(ChapterListViewItem(
        bookName: widget.bookName,
        chapterNumber: (index + 1).toString(),
        chapterName: chapterList[index],
      ));
    }
    return chapterListViewItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: createChapterList(chapterList),
    );
  }
}

class ChapterListViewItem extends StatelessWidget {
  final String bookName;
  final String chapterNumber;
  final String chapterName;

  const ChapterListViewItem({
    Key? key,
    required this.bookName,
    required this.chapterNumber,
    required this.chapterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store store) {
        debugPrint("store in chapter_listview_item");
        /// 切换到别的书籍，设定解析addTextParser初始化
        void clickAnotherBook() {
          Map<String, Set<String>> newParserModel = Parser.getBookInitParserModel(appGetIt.get(instanceName: "IOBase"), bookName);
          store.dispatch(SetParserDataAction(parserObj: newParserModel));
        }
        return () => {
          if (store.state.textModel.currentBook.toString().compareTo(bookName) != 0){
            store.dispatch(SetTextDataAction(currentBook: bookName, currentChapter: chapterName, currentChapterNumber: chapterNumber),),
            clickAnotherBook(),
          } else {
            store.dispatch(SetTextDataAction(currentBook: bookName, currentChapter: chapterName, currentChapterNumber: chapterNumber),),
          },
        };
      },
      builder: (BuildContext context, VoidCallback clickChapter) {
        return InkWell(
          child: Container(
            height: height / 18.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).dividerColor,
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20,),
                Text('第$chapterNumber章'),
                const SizedBox(width: 20,),
                Flexible(
                  child: Text(
                    chapterName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            clickChapter();
          },
        );
      },
    );
  }
}
