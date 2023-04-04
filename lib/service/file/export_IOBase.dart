import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
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
    /// 先创建目录chs
    Directory dir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookChsDirPath(bookName)}");
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    File file = File("$_appDocPath${Platform.pathSeparator}${FileConfig.writeBookChapterFilePath(bookName, chapterName)}");
    file.copySync("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookChapterFilePath(bookName, chapterName)}");
  }

  /// 导出书本全部章节
  void exportBook(String bookName, List<String> chapterList) {
    /// 先清空原有的导出文件
    Directory dir = Directory("$_appDocPath${Platform.pathSeparator}${FileConfig.exportBookBokDirPath(bookName)}");
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync(recursive: true);

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

  /// 导出可移植.zip, wWriter/webdav/${bookName}.zip
  Future<void> exportZipForWebDAV(String bookName) async {
    var encoder = ZipFileEncoder();
    encoder.create("$_appDocPath${Platform.pathSeparator}${FileConfig.webDAVLocalBookFilePath(bookName)}");
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

  /////////////////////////////////////////////////////////////////////////////
  //                                导入.zip文件                              //
  ////////////////////////////////////////////////////////////////////////////
  Future<String> importBook() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["zip"],
      lockParentWindow: true
    );

    String bookName = "";
    if (result != null) {
      bookName = result.files.single.name.split(".").first;
      // Use an InputFileStream to access the zip file without storing it in memory.
      final inputStream = InputFileStream(result.files.single.path??"");
      // Decode the zip from the InputFileStream. The archive will have the contents of the
      // zip, without having stored the data in memory.
      final archive = ZipDecoder().decodeBuffer(inputStream);
      extractArchiveToDisk(archive, "$_appDocPath${Platform.pathSeparator}${FileConfig.writeRootDirPath()}");
    } else {
      // User canceled the picker
    }

    return bookName;
  }
}