import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer2/components/toast_dialog.dart';
import 'package:writing_writer2/components/transparent_icon_button.dart';
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
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StoreConnector<AppState, Function(String, String)>(
      converter: (Store store) {
        return (String bookName, String chapterName) => {
              store.state.ioBase.createChapter(bookName, chapterName),
        };
      },
      builder: (BuildContext context, Function(String, String) createChapter) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: SizedBox(
                height: height / 15.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        widget.bookName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          wordSpacing: 2.0,
                        ),
                      ),
                    ),
                    TransIconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ToastDialog(
                            title: '新建章节',
                            callBack: (strBack) => {
                              if (strBack.isNotEmpty) {
                                createChapter(widget.bookName, strBack),
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
