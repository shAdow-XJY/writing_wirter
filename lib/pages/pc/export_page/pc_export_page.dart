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

  List<String> bookNameList = [];

  @override
  void initState() {
    super.initState();
    bookNameList = ioBase.getAllBooks();
  }

  Card getCard(String bookName) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor.withOpacity(0.5), Theme.of(context).primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bookName,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.article_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SelectToastDialog(
                            items: ioBase.getAllChapters(bookName),
                            title: '选择导出的章节',
                            callBack: (exportChapterName) => {
                              if (exportChapterName.isNotEmpty)
                                {
                                  exportIOBase.exportChapter(
                                      bookName, exportChapterName),
                                },
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text("导出章节"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.book_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TextToastDialog(
                            title: '导出书籍',
                            text: '确定导出书籍$bookName',
                            callBack: () => {
                              exportIOBase.exportBook(bookName, ioBase.getAllChapters(bookName)),
                              Navigator.pop(context),
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text("导出书籍"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.archive_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TextToastDialog(
                            title: '导出.zip可移植文件',
                            text: '确定导出书籍$bookName.zip可移植文件',
                            callBack: () => {
                              exportIOBase.exportZip(bookName),
                              Navigator.pop(context),
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text("导出.zip"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.folder_open_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => TextToastDialog(
                            title: '导出.zip可移植文件',
                            text: '确定书籍$bookName导出文件位置',
                            callBack: () => {
                              exportIOBase.openFileManager(bookName),
                              Navigator.pop(context),
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text("打开本地"),
                  ],
                ),
              ],
            ),
          ],
        ),
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
        actions: [
          TextButton(
            child: const Text("导入可移植.zip书籍文件"),
            onPressed: () {
              exportIOBase.importBook().then((importBookName) {
                if (importBookName.isNotEmpty) {
                  setState(() {
                    bookNameList.add(importBookName);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: bookNameList.length,
        itemBuilder: (context, index) {
          return getCard(bookNameList[index]);
        },
      ),
    );
  }
}
