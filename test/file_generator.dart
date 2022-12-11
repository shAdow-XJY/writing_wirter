import 'dart:io';

/// 文件脚本
Future<void> main() async {
  /// 对static/《西游记》.txt 文件操作的脚本，生成每一章节的文件
  readOriginTxt("E:\\AndroidStudioProjects\\writing_writer\\static\\《西游记》.txt", RegExp(r'第.{1,3}回', multiLine: true));
}
/// 读取处理源文字文件
Future<void> readOriginTxt(String path, RegExp regExp) async {
  File file = File(path);
  if(!file.existsSync()){
    return;
  }

  // print(prePath);
  // print(bookName);
  final content = file.readAsStringSync();
  // print(content.length);
  Iterable matches = regExp.allMatches(content);
  var matchList = [];
  var indexList = [];
  for (final Match m in matches) {
    String match = m[0]!;
    // print(match);
    matchList.add(match);
    indexList.add(content.indexOf(match));
  }
  indexList.add(content.length - 1);

  String prePath = path.substring(0, path.lastIndexOf('\\')+1);
  String bookName = path.substring(path.lastIndexOf('\\')+1, path.length);
  bookName = bookName.substring(0, bookName.lastIndexOf('.'));
  /// 创建同级同名目录文件夹
  String newPath = prePath + bookName;
  createDir(newPath);
  /// 目录下创建文件
  newPath += '\\';
  for (var i = 0; i < indexList.length - 1; ++i) {
    // print(indexList[i]);
    // print(content.substring(indexList[i], indexList[i+1]));
    createFile(newPath + matchList[i], content.substring(indexList[i], indexList[i+1]));
  }
}
/// 根据名字生成文件夹
Future<void> createDir(String path) async {
  Directory dir = Directory(path);
  print(dir.path);
  if(!dir.existsSync()){
    dir.create();
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