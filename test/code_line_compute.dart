import 'dart:io';

int fileCount = 0;
int lineCount = 0;
/// 读取lib目录文件，统计代码行数脚本
Future<void> main() async {
  recursionFile("E:\\AndroidStudioProjects\\writing_writer\\lib");
  print("files number in /lib：$fileCount");
  print("lines number in /lib：$lineCount");
}
void recursionFile(String pathName) {
  Directory dir = Directory(pathName);

  if (!dir.existsSync()) {
    return;
  }

  List<FileSystemEntity> lists = dir.listSync();
  for (FileSystemEntity entity in lists) {

    fileCount = fileCount + 1;

    if (entity is File) {
      File file = entity;
      final content = file.readAsStringSync();
      lineCount += content.split("\n").length;
    } else if (entity is Directory) {
      Directory subDir = entity;
      recursionFile(subDir.path);
    }
  }
}
// ————————————————
// 版权声明：本文为CSDN博主「gaoyp」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
// 原文链接：https://blog.csdn.net/gaoyp/article/details/128257680