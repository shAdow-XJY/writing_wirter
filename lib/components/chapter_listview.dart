import 'package:flutter/material.dart';
import 'package:writing_writer/server/file/IOBase.dart';

class ChapterListView extends StatefulWidget {
  final IOBase ioBase;
  final String bookName;
  const ChapterListView({
    Key? key,
    required this.ioBase,
    required this.bookName,
  }) : super(key: key);

  @override
  State<ChapterListView> createState() => _ChapterListViewState();
}

class _ChapterListViewState extends State<ChapterListView> {
  late final String bookName;
  List<String> chapterList = [];
  List<Widget> chapterItems = [];

  @override
  void initState() {
    super.initState();
    bookName = widget.bookName;
    chapterList = widget.ioBase.getAllChapters(bookName);
    createChapterList(chapterList);
  }

  List<Widget> createChapterList(List<String> chapterList) {
    chapterItems.clear();
    for (var chapterName in chapterList) {
      chapterItems.add(ChapterListViewItem(chapterName: chapterName,));
    }
    return chapterItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: chapterItems,
    );
  }

}

class ChapterListViewItem extends StatelessWidget {
  final String chapterName;

  const ChapterListViewItem({
    Key? key,
    required this.chapterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chapterName),
          Icon(Icons.arrow_drop_up),
        ],
      ),
      onTap: () {
      },
    );
  }

}
