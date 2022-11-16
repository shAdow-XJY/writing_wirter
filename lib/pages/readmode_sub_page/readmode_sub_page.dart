import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../redux/action/set_action.dart';
import '../../redux/app_state/state.dart';
import '../../server/parser/StringParser.dart';

class ReadModeSubPage extends StatefulWidget {
  const ReadModeSubPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ReadModeSubPage> createState() => _ReadModeSubPageState();
}

class _ReadModeSubPageState extends State<ReadModeSubPage> {

  /// text
  String currentBook = "";
  String currentChapter = "";
  String currentText = "";

  String currentSet = "";
  String currentSetting = "";

  final parser = StringParser('', {});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InlineSpan>(
      converter: (Store store) {
        currentBook = store.state.textModel.currentBook;
        currentChapter = store.state.textModel.currentChapter;
        currentText = store.state.ioBase.getChapterContent(currentBook, currentChapter);
        currentSet = store.state.setModel.currentSet;
        currentSetting = store.state.setModel.currentSetting;
        parser.resetContent(currentText);
        parser.resetParser(store.state.parserModel.currentParser);
        print(store.state.parserModel.currentParser);
        /// 点击高亮
        parser.addOnTapEvent(()=>{
          store.dispatch(SetSetDataAction(currentSet: currentSet, currentSetting: currentSetting)),
        });
        return parser.inlineSpan;
      },
      builder: (BuildContext context, InlineSpan inlineSpan) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text.rich(inlineSpan),
        );
      },
    );
  }
}
