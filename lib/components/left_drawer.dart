import 'package:flutter/material.dart';
import 'book_listview.dart';


class LeftDrawer extends StatefulWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 4.0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Directory'),
          leading: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: (){
                Navigator.of(context).pop();
              },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: (){
                //ioBase.createBook('bookName');
                //ioBase.getChapterContent('bookName', 'bookName');
              },
            ),
          ],
        ),
        body: const BookListView(),
      ),
    );
  }
  
}