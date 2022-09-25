import 'package:flutter/material.dart';
import 'package:writing_writer/server/file/IOBase.dart';
import 'chapter_listview.dart';

class BookListView extends StatefulWidget {
  final IOBase ioBase;
  final List<String> bookNameList;

  const BookListView({
    Key? key,
    required this.ioBase,
    required this.bookNameList,
  }) : super(key: key);

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  late final List<String> bookNameList;

  @override
  void initState() {
    super.initState();
    bookNameList = widget.bookNameList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        height: 1,
        color: Colors.white24,
      ),
      controller: ScrollController(),
      itemCount: bookNameList.length,
      itemBuilder: (context, index) => BookListViewItem(
        ioBase: widget.ioBase,
        bookName: bookNameList[index],
      ),
    );
  }
}


class BookListViewItem extends StatefulWidget {
  final IOBase ioBase;
  final String bookName;

  const BookListViewItem({
    Key? key,
    required this.ioBase,
    required this.bookName,
  }) : super(key: key);

  @override
  State<BookListViewItem> createState() => _BookListViewItemState();
}

class _BookListViewItemState extends State<BookListViewItem> {
  late final String bookName;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    bookName = widget.bookName;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bookName),
              Icon(isExpanded ? Icons.arrow_drop_down : Icons.arrow_drop_up),
            ],
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        isExpanded ? ChapterListView(
          ioBase: widget.ioBase,
          bookName: bookName,
        ) : const SizedBox(),
      ],
    );
  }
}