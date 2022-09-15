import 'package:flutter/material.dart';
import 'package:writing_writer/components/my_listview.dart';
import 'package:writing_writer/server/file/IOBase.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({Key? key,}) : super(key: key);

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {

  IOBase ioBase = IOBase();
  @override
  void initState() {
    // TODO: implement initState
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
                ioBase.getChapterContent('bookName', 'bookName');
              },
            ),
          ],
        ),
        body: MyListView(),
      ),
    );
  }
  
}