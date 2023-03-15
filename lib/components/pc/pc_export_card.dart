import 'package:flutter/material.dart';

class PCExportCard extends StatelessWidget {
  final String bookName;

  const PCExportCard({
    Key? key,
    required this.bookName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(bookName),
          TextButton(
            child: const Text("导出某一章节"),
            onPressed: () {},
          ),
          TextButton(
            child: const Text("导出全部章节"),
            onPressed: () {},
          ),
          TextButton(
            child: const Text("导出.zip可移植文件"),
            onPressed: () {},
          ),
          TextButton(
            child: const Text("打开导出文件位置"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}