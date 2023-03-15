import 'package:flutter/material.dart';
import 'package:writing_writer/service/file/export_IOBase.dart';
import '../../../components/common/dialog/select_toast_dialog.dart';
import '../../../components/common/dialog/text_toast_dialog.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class PCExportPage extends StatefulWidget {
  const PCExportPage({
    super.key,
  });

  @override
  State<PCExportPage> createState() => _PCExportPageState();
}

class _PCExportPageState extends State<PCExportPage> {
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
        title: const Text("本地书籍导出"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: bookNameList.length,
        itemBuilder: (context, index) {
          return getCard(bookNameList[index]);
        },
      ),
    );
  }
}
