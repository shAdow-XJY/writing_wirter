import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:writing_writer/components/common/animated/slide_icon.dart';
import 'package:writing_writer/service/file/export_IOBase.dart';
import '../../../components/common/dialog/select_toast_dialog.dart';
import '../../../components/common/dialog/text_toast_dialog.dart';
import '../../../components/common/transparent_bar_scroll_view.dart';
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

  Slidable getSlidable(String bookName) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: 0.4,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
              backgroundColor: const Color(0xFFBE0909),
              foregroundColor: Colors.white,
              icon: Icons.archive_outlined,
              label: '.zip',
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) => TextToastDialog(
                    title: '分享.zip可移植文件',
                    text: '确定.zip可移植书籍文件 $bookName.zip?',
                    callBack: () => {
                      exportIOBase.shareZip(bookName),
                      Navigator.pop(context),
                    },
                  ),
                );
              }
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
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
                    exportIOBase.shareBook(bookName, ioBase.getAllChapters(bookName)),
                    Navigator.pop(context),
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
        actions: const [
          SlideIcon(icon: Icon(CupertinoIcons.hand_draw_fill, size: 30)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 3.0,);
        },
        itemCount: bookNameList.length,
        itemBuilder: (context, index) {
          return getSlidable(bookNameList[index]);
        },
      ),
    );
  }
}