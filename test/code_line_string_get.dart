import 'dart:io';

import 'package:flutter/foundation.dart';

int lineCount = 0;
List<String> codeLines = [];

/// 读取lib目录文件，统计代码行数脚本
Future<void> main() async {
  recursionFile("E:\\AndroidStudioProjects\\writing_writer\\lib");
  if (kDebugMode) {
    print("lines number in /lib: $lineCount");

    // 获取前面连续的1500行代码
    List<String> first1500Lines = codeLines.sublist(0, 1500);
    // print("First 1500 lines:\n${first1500Lines.join("\n")}");
    createFile('E:\\AndroidStudioProjects\\writing_writer\\static\\generator\\pre_1500_lines.txt', first1500Lines.join("\n"));

    // 获取最后连续的1500行代码
    List<String> last1500Lines = codeLines.sublist(codeLines.length - 1500);
    // print("Last 1500 lines:\n${last1500Lines.join("\n")}");
    createFile('E:\\AndroidStudioProjects\\writing_writer\\static\\generator\\last_1500_lines.txt', last1500Lines.join("\n"));

  }
}

void recursionFile(String pathName) {
  Directory dir = Directory(pathName);

  if (!dir.existsSync()) {
    return;
  }

  List<FileSystemEntity> lists = dir.listSync();
  for (FileSystemEntity entity in lists) {
    if (entity is File) {
      File file = entity;
      final content = file.readAsStringSync();
      List<String> lines = content.split("\n");
      for (String line in lines) {
        // 判断是否为空行（只包含空白字符的行）
        if (line.trim().isNotEmpty) {
          lineCount += 1;
          codeLines.add(line);
        }
      }
    } else if (entity is Directory) {
      Directory subDir = entity;
      recursionFile(subDir.path);
    }
  }
}

/// 根据路径和内容生成文件
Future<void> createFile(String path, String content) async {
  File file = File(path);
  if(!file.existsSync()){
    file.create();
  }
  await file.writeAsString(content, mode: FileMode.write);
}