import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../components/common/dialog/edit_toast_dialog.dart';
import '../../../components/common/toast/global_toast.dart';
import '../../../service/file/IOBase.dart';
import '../../../state_machine/get_it/app_get_it.dart';
import '../../../state_machine/redux/action/text_action.dart';
import '../../../state_machine/redux/app_state/state.dart';

class ChapterEditPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ChapterEditPageAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ChapterEditPageAppBar> createState() => _ChapterEditPageAppBarState();
}

class _ChapterEditPageAppBarState extends State<ChapterEditPageAppBar> {
  /// 全局单例-文件操作工具类
  final IOBase ioBase = appGetIt.get(instanceName: "IOBase");

  /// text
  String currentBook = "";
  String currentChapter = "";

  /// 详情框打开状态
  bool isDetailOpened = false;

  /// 章节重命名
  void changeChapterName(String newChapterName) {
    if (newChapterName.compareTo(currentChapter) == 0) {
      return;
    }
    // 重命名文件
    ioBase.renameChapter(currentBook, currentChapter, newChapterName);
    currentChapter = newChapterName;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, dynamic>>(
        converter: (Store store) {
      debugPrint('store in home_page');
      currentBook = store.state.textModel.currentBook;
      currentChapter = store.state.textModel.currentChapter;
      void renameChapter() {
        store.dispatch(SetTextDataAction(
            currentBook: currentBook, currentChapter: currentChapter));
      }

      return {
        "currentChapter": currentChapter,
        "renameChapter": renameChapter,
      };
    }, builder: (BuildContext context, Map<String, dynamic> map) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.book),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        centerTitle: true,
        title: map["currentChapter"].toString().isEmpty
            ? const Text('no chapter selected')
            : InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 5.0,),
                    Flexible(
                      child: Text(
                        map["currentChapter"],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditToastDialog(
                      title: '章节重命名',
                      init: currentChapter,
                      callBack: (strBack) => {
                        if (strBack.isNotEmpty)
                          {
                            changeChapterName(strBack),
                            map["renameChapter"](),
                            Navigator.pop(context),
                          }
                        else
                          {
                            GlobalToast.showErrorTop(
                              '章节名字不能为空',
                            ),
                          },
                      },
                    ),
                  );
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      );
    });
  }
}
