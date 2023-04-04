import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:writing_writer/service/file/export_IOBase.dart';
import 'package:writing_writer/service/web_dav/web_dav.dart';
import '../../../components/common/dialog/select_toast_dialog.dart';
import '../../../service/file/IOBase.dart';
import '../../../service/file/config_IOBase.dart';
import '../../../state_machine/event_bus/webDAV_events.dart';
import '../../../state_machine/get_it/app_get_it.dart';

class CloudPage extends StatefulWidget {
  const CloudPage({
    super.key,
  });

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");

  /// 全局单例-文件导出操作工具类
  final ExportIOBase exportIOBase = appGetIt.get(instanceName: "ExportIOBase");

  /// 全局单例-用户配置文件操作工具类
  final ConfigIOBase configIOBase = appGetIt.get(instanceName: "ConfigIOBase");

  /// 全局单例-事件总线工具类
  final EventBus eventBus = appGetIt.get(instanceName: "EventBus");
  late StreamSubscription subscription_1;
  late StreamSubscription subscription_2;

  /// webDAV 信息
  late Map<String, dynamic> webDAVInfo;
  late WebDAV webDAV;

  /// webDAV 登录状态标志flag,避免刷新重新创建连接
  bool linking = true;
  bool linkFailed = true;

  /// 书籍名称列表
  List<Map<String, dynamic>> webDAVBookList = [];
  List<String> localBookList = [];

  @override
  void initState() {
    super.initState();
    webDAV = WebDAV(eventBus);
    webDAVInfo = configIOBase.getWevDAVInfo();
    webDAV.login(webDAVInfo["uri"], webDAVInfo["user"], webDAVInfo["password"]).then((result) => {
      setState(() {
        linkFailed = !result;
        linking = false;
      })
    });
    localBookList = ioBase.getAllBooks();
    subscription_1 = eventBus.on<WebDavUploadBookDoneEvent>().listen((event) {
      setState(() {});
    });
    subscription_2 = eventBus.on<WebDavRemoveBookDoneEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription_1.cancel();
    subscription_2.cancel();
    webDAV.close();
  }

  List<String> getUploadBookList() {
    debugPrint("getUploadBookList");
    List<String> uploadBookList = ioBase.getAllBooks();
    for (var element in webDAVBookList) {
      String name = element["name"];
      name = name.substring(0, name.length - 4);
      if (uploadBookList.contains(name)) {
        uploadBookList.remove(name);
      }
    }
    return uploadBookList;
  }

  ExpansionTileCard getCard(Map<String, dynamic> bookInfo) {
    // 书籍名字处理，去除".zip"后缀
    String bookName = bookInfo["name"];
    bookName = bookName.substring(0, bookName.length - 4);
    // 云端书籍是否在本地也有同名书籍
    bool inLocal = localBookList.contains(bookName);

    return ExpansionTileCard(
      leading: CircleAvatar(child: Text(bookName[0])),
      title: Text(bookName),
      initialPadding: const EdgeInsets.only(top: 6.0),
      children: [
        const Divider(
          thickness: 1.0,
          height: 1.0,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("书籍在本地：${inLocal ? "书籍存在本地" : "书籍不存在本地"}",),
                  Text("云端存储时间版本：${bookInfo["time"]}"),
                ],
              )),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceAround,
          buttonHeight: 52.0,
          buttonMinWidth: 90.0,
          children: <Widget>[
            TextButton(
              child: Column(
                children: [
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.blueAccent,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    inLocal ? "覆盖本地" : "导入本地",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                await webDAV.downloadBook(bookName);
                await exportIOBase.importZipFromWebDAV(bookName);
              },
            ),
            TextButton(
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: inLocal ? Colors.blueAccent : Colors.blueGrey,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    '同步云端',
                    style: TextStyle(
                      color: inLocal ? Colors.blueAccent : Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                if (!inLocal) {
                  return;
                }
                await exportIOBase.exportZipForWebDAV(bookName);
                await webDAV.uploadBook(bookName);
              },
            ),
            TextButton(
              child: Column(
                children: const [
                  Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.redAccent,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text(
                    '云端删除',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                await webDAV.removeBook(bookName);
              },
            ),
          ],
        ),
      ],
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
        title: const Text("云端书籍存储"),
        actions: [
          TextButton(
            child: const Text("上传书籍"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SelectToastDialog(
                  items: getUploadBookList(),
                  title: '选择上传至云端的书籍',
                  callBack: (uploadBookName) async => {
                    if (uploadBookName.isNotEmpty)
                      {
                        await exportIOBase.exportZipForWebDAV(uploadBookName),
                        await webDAV.uploadBook(uploadBookName),
                      },
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: linking
          ? const Center(child: CircularProgressIndicator())
          : linkFailed
              ? const Center(child: Text('Error: 登录WebDAV失败'))
              : FutureBuilder(
                  future: webDAV.getAllBooks(),
                  builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        webDAVBookList = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: webDAVBookList.length,
                          itemBuilder: (context, index) {
                            return getCard(webDAVBookList[index]);
                          },
                        );
                    }
                  },
                ),
    );
  }
}
