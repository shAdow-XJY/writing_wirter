import 'package:flutter/material.dart';
import 'package:writing_writer/components/pc/pc_export_card.dart';
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

  List<String> bookNameList= [];

  @override
  void initState() {
    super.initState();
    bookNameList = ioBase.getAllBooks();
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
          return PCExportCard(
            bookName: bookNameList[index],
          );
        },
      ),
    );
  }
}
