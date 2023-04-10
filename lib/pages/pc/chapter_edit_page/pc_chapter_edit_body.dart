import 'package:click_text_field/click_text_field.dart';
import 'package:flutter/material.dart';
import '../../common/chapter_edit_page/common_chapter_edit_body.dart';

class PCChapterEditPageBody extends StatefulWidget {
  const PCChapterEditPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<PCChapterEditPageBody> createState() => _PCChapterEditPageBodyState();
}

class _PCChapterEditPageBodyState extends State<PCChapterEditPageBody> {

  /// 章节内容输入框控制器
  final ClickTextEditingController clickTextEditingController = ClickTextEditingController();


  @override
  Widget build(BuildContext context) {
    return CommonChapterEditPageBody(clickTextEditingController: clickTextEditingController,);
  }
}
