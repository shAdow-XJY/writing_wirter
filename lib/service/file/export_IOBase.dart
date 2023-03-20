import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'file_configure.dart';

class ExportIOBase
{
  /// 电脑文档目录路径
  late final String _appDocPath;

  ExportIOBase() {
    getApplicationDocumentsDirectory().then((appDocDir) => {
      _appDocPath = appDocDir.path,
      _init(),
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                私有函数                                  //
  ////////////////////////////////////////////////////////////////////////////

  /// 构造函数内部使用：初始化函数
  void _init() {
    /// 创建应用文件夹
    Directory rootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.rootDirPath()}");
    if (!rootDir.existsSync()){
      rootDir.createSync(recursive: true);
      // debugPrint(_rootDir.path);
    }

    /// 创建应用子文件夹：导出文件夹
    Directory exportRootDir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportRootDirPath()}");
    if (!exportRootDir.existsSync()){
      exportRootDir.createSync(recursive: true);
    }
  }

  /// 根据路径打开资源管理器
  void openFileManager(String bookName) {
    final Uri url = Uri.file("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookDirPath(bookName)}");
    /// launchUrl(url);
    /// 改用下面的方法解决路径中包含中文导致打开失败
    launchUrlString(url.toFilePath());
  }
  /////////////////////////////////////////////////////////////////////////////
  //                                导出文件                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// 导出书本某一章节
  void exportChapter(String bookName, String chapterName) {
    File file = File("$_appDocPath${Platform.pathSeparator}${FileConfig.writeBookChapterFilePath(bookName, chapterName)}");
    file.copySync("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookChapterFilePath(bookName, chapterName)}");
  }

  /// 导出书本全部章节
  void exportBook(String bookName, List<String> chapterList) {
    /// 先清空原有的导出文件
    Directory dir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookBokDirPath(bookName)}");
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
      dir.createSync(recursive: true);
    }

    for (var index = 0; index < chapterList.length; ++index) {
      File file = File("$_appDocPath${Platform.pathSeparator}${FileConfig.writeBookChapterFilePath(bookName, chapterList[index])}");
      file.copySync("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookBokChapterFilePath(bookName, index+1, chapterList[index])}");
    }
  }

  /// 导出可移植.zip（包含chapter 和 set）
  Future<void> exportZip(String bookName) async {
    var encoder = ZipFileEncoder();
    encoder.create("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookZipFilePath(bookName)}");
    await encoder.addDirectory(Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.writeBookDirPath(bookName)}"));
    encoder.close();
  }

  /////////////////////////////////////////////////////////////////////////////
  //                                导出文件                                  //
  ////////////////////////////////////////////////////////////////////////////
  /// 分享单一章节
  void shareChapter(String bookName, String chapterName) {
    exportChapter(bookName, chapterName);
    Share.shareXFiles([XFile("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookChapterFilePath(bookName, chapterName)}")], text: 'share chapter');
  }

  /// 分享全书
  Future<void> shareBook(String bookName, List<String> chapterList) async {
    exportBook(bookName, chapterList);
    var encoder = ZipFileEncoder();
    encoder.create("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookZipFilePath(bookName)}");
    await encoder.addDirectory(Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookBokDirPath(bookName)}"));
    encoder.close();
    Share.shareXFiles([XFile("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookZipFilePath(bookName)}")], text: 'share book');
  }
  // void importBook(String bookName) {
  //   // Read the Zip file from disk.
  //   final bytes = File('test.zip').readAsBytesSync();
  //
  //   // Decode the Zip file
  //   final archive = ZipDecoder().decodeBytes(bytes);
  //
  //   // Extract the contents of the Zip archive to disk.
  //   for (final file in archive) {
  //     final filename = file.name;
  //     if (file.isFile) {
  //       final data = file.content as List<int>;
  //       File('out/' + filename)
  //         ..createSync(recursive: true)
  //         ..writeAsBytesSync(data);
  //     } else {
  //       Directory('out/' + filename).create(recursive: true);
  //     }
  //   }
  // }
}