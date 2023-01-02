import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

const clickTextStyle = TextStyle(
  color: Colors.deepPurple,
);
class ClickTextEditingController extends TextEditingController{

  RegExp _regExp = RegExp(r'');
  StringScanner _scanner = StringScanner("");
  Function(String) _onTap = (String clickText){};

  void setRegExp(RegExp regExp) {
    _regExp = regExp;
  }

  void setOnTapEvent(Function(String) onTap) {
    _onTap = onTap;
  }

  void runOnTapEvent(String clickText) {
    _onTap(clickText);
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    // debugPrint('scanning text as follow:');
    // debugPrint(text);
    var atIndex = 0;
    var spans = <InlineSpan>[];

    _scanner = StringScanner(text);
    if (_regExp.pattern.isNotEmpty) {
      while (!_scanner.isDone) {
        // debugPrint('scanning');
        if (_scanner.scan(_regExp)) {
          int startIndex = _scanner.lastMatch?.start ?? 0 ;
          int endIndex = _scanner.lastMatch?.end ?? 0;
          if (startIndex < endIndex) {
            spans.add(
                TextSpan(
                  text: text.substring(atIndex, startIndex),
                  mouseCursor: SystemMouseCursors.text,
                  recognizer: null,
                )
            );
            spans.add(
              TextSpan(
                  text: text.substring(startIndex, endIndex),
                  style: clickTextStyle,
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()..onTap = ()=> {
                    // debugPrint(text.substring(startIndex, endIndex)),
                    runOnTapEvent(text.substring(startIndex, endIndex)),
                  }
              ),
            );
            // debugPrint('is highlight text span!!!!');
            // print(_regExp);
            // debugPrint('scanning match');
            // debugPrint('scanning match startIndex:');
            // debugPrint(startIndex.toString());
            // debugPrint('scanning match endIndex:');
            // debugPrint(endIndex.toString());
            // debugPrint(text.substring(startIndex, endIndex));
            atIndex = endIndex;
          }
        }
        _scanner.position++;
      }
    }
    _scanner.position = 0;
    spans.add(
        TextSpan(
            text: text.substring(atIndex, (text.length - 1 > 0) ? text.length - 1 : 0),
            mouseCursor: SystemMouseCursors.text,
            recognizer: null,
        )
    );
    // debugPrint('build TextSpan successfully');
    return TextSpan(
      children: spans,
      mouseCursor: SystemMouseCursors.text,
      recognizer: null,
    );
  }
}