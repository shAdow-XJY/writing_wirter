import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:writing_writer/service/file/export_IOBase.dart';
import '../../../components/common/dialog/select_toast_dialog.dart';
import '../../../components/common/dialog/text_toast_dialog.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class MobileExportPage extends StatefulWidget {
  const MobileExportPage({
    super.key,
  });

  @override
  State<MobileExportPage> createState() => _MobileExportPageState();
}

class _MobileExportPageState extends State<MobileExportPage> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");
  /// 全局单例-文件导出操作工具类
  final ExportIOBase exportIOBase = appGetIt.get(instanceName: "ExportIOBase");

  List<String> bookNameList= [];

  @override
  void initState() {
    super.initState();
    bookNameList = ioBase.getAllBooks();
  }

  Card getCard(String bookName) {
    return Card(
      child: Column(
        children: [
          Text(bookName),
          TextButton(
            child: const Text("导出某一章节"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SelectToastDialog(
                  items: ioBase.getAllChapters(bookName),
                  title: '选择导出的章节',
                  callBack: (exportChapterName) => {
                    if (exportChapterName.isNotEmpty) {
                      exportIOBase.exportChapter(bookName, exportChapterName),
                    },
                  },
                ),
              );
            },
          ),
          TextButton(
            child: const Text("导出全部章节"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TextToastDialog(
                  title: '导出书籍',
                  text: '确定导出书籍$bookName',
                  callBack: () => {
                    exportIOBase.exportBook(bookName),
                  },
                ),
              );
            },
          ),
          TextButton(
            child: const Text("导出.zip可移植文件"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TextToastDialog(
                  title: '导出.zip可移植文件',
                  text: '确定导出书籍$bookName.zip可移植文件',
                  callBack: () => {
                    exportIOBase.exportZip(bookName),
                  },
                ),
              );
            },
          ),
          TextButton(
            child: const Text("打开导出文件位置"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TextToastDialog(
                  title: '导出.zip可移植文件',
                  text: '确定书籍$bookName导出文件位置',
                  callBack: () => {
                  exportIOBase.openFileManager(bookName),
                },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Slidable getSlidable(String bookName) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.newspaper,
            label: '单章',
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => SelectToastDialog(
                  items: ioBase.getAllChapters(bookName),
                  title: '选择分享的章节',
                  callBack: (exportChapterName) => {
                    if (exportChapterName.isNotEmpty) {
                      exportIOBase.shareChapter(bookName, exportChapterName),
                    },
                  },
                ),
              );
            }
          ),
          SlidableAction(
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.book,
            label: '全书',
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => TextToastDialog(
                  title: '分享书籍',
                  text: '确定分享书籍$bookName',
                  callBack: () => {
                    exportIOBase.shareBook(bookName),
                  },
                ),
              );
            }
          ),
        ],
      ),
      child: Container(
        height: 60.0,
        alignment: Alignment.center,
        color: Theme.of(context).focusColor,
        margin: const EdgeInsets.only(top: 3.0),
        child: Text(bookName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text("本地书籍分享"),
      ),
      body: ListView.builder(
        itemCount: bookNameList.length,
        itemBuilder: (context, index) {
          return getSlidable(bookNameList[index]);
        },
      ),
    );
  }
}
