import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/action/text_action.dart';
import '../redux/app_state/state.dart';

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
  late final String bookName;
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(chapterName),
              const Icon(Icons.book),
            ],
          ),
          onTap: () {
            clickChapter();
          },
        );
      },
    );
  }
}
