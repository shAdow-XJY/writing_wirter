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

  /// webDAV 信息
  late Map<String, dynamic> webDAVInfo;
  late WebDAV webDAV;

  /// webDAV 登录状态标志flag,避免刷新重新创建连接
  bool linking = true;
  bool linkFailed = true;

  /// 书籍名称列表
  List<Map<String, dynamic>> webDAVBookList = [];
  List<String> uploadBookList = [];

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
    uploadBookList = ioBase.getAllBooks();
    subscription_1 = eventBus.on<WebDavUploadBookDoneEvent>().listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription_1.cancel();
    webDAV.close();
  }

  List<String> getUploadBookList() {
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
    String name = bookInfo["name"];
    name = name.substring(0, name.length - 4);
    return ExpansionTileCard(
      leading: CircleAvatar(child: Text(name[0])),
      title: Text(name),
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
                children: [
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
              onPressed: () {},
              child: Column(
                children: const [
                  Icon(Icons.arrow_downward),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('导入本地'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Column(
                children: const [
                  Icon(Icons.arrow_upward),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('同步云端'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Column(
                children: const [
                  Icon(Icons.delete_forever_rounded),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Text('云端删除'),
                ],
              ),
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
