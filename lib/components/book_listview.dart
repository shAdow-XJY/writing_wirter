import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../redux/app_state/state.dart';
import 'chapter_listview.dart';

class BookListView extends StatefulWidget {

  const BookListView({
    Key? key,
  }) : super(key: key);

  @override
  State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<String>>(
      converter: (Store store) {
        return store.state.ioBase.getAllBooks();
      },
      builder: (BuildContext context, List<String> bookNameList) {
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            thickness: 1,
            height: 1,
            color: Colors.white24,
          ),
          controller: ScrollController(),
          itemCount: bookNameList.length,
          itemBuilder: (context, index) => BookListViewItem(
            bookName: bookNameList[index],
          ),
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
        isExpanded
            ? ChapterListView(
                bookName: bookName,
              )
            : const SizedBox(),
      ],
    );
  }
}
