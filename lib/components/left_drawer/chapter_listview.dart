import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../redux/action/text_action.dart';
import '../../redux/app_state/state.dart';

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
  List<Widget> chapterListViewItems = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> createChapterList(List<String> chapterList) {
    chapterListViewItems.clear();
    for (var chapterName in chapterList) {
      chapterListViewItems.add(ChapterListViewItem(
        bookName: widget.bookName,
        chapterName: chapterName,
      ));
    }
    return chapterListViewItems;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store store) {
        return store.state.ioBase.getAllChapters(widget.bookName);
      },
      builder: (BuildContext context, List<String> chapterList) {
        return Column(
          children: createChapterList(chapterList),
        );
      },
    );
  }
}

class ChapterListViewItem extends StatelessWidget {
  final String bookName;
  final String chapterName;

  const ChapterListViewItem({
    Key? key,
    required this.bookName,
    required this.chapterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store store) {
        return () => {
          store.dispatch(
            SetTextDataAction(currentBook: bookName, currentChapter: chapterName),
          ),
        };
      },
      builder: (BuildContext context, VoidCallback clickChapter) {
        return InkWell(
          child: Container(
            height: height / 18.0,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              border: Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.inversePrimary,
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chapterName),
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
