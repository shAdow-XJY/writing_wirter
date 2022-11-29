import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

const clickTextStyle = TextStyle(
  color: Colors.deepPurple,
);
class ClickTextEditingController extends TextEditingController{

  StringScanner _scanner = StringScanner("");

  RegExp _regExp = RegExp(r'');
  void setRegExp(RegExp regExp) {
    _regExp = regExp;
  }

  Function(String)? _onTap;
  void setOnTapEvent(Function(String) onTap) {
    _onTap = onTap;
  }

  @override
  set text(String newText) {
    // TODO: implement text
    super.text = newText;
    _scanner = StringScanner(text);
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

    while (!_scanner.isDone) {
      // debugPrint('scanning');

      if (_scanner.scan(_regExp)) {
        int startIndex = _scanner.lastMatch?.start ?? 0 ;
        int endIndex = _scanner.lastMatch?.end ?? 0;

        spans.add(TextSpan(text: text.substring(atIndex, startIndex)));
        spans.add(
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: clickTextStyle,
            recognizer: TapGestureRecognizer()..onTap = ()=> {
              debugPrint(text.substring(startIndex, endIndex)),
              _onTap!(text.substring(startIndex, endIndex)),
            }
          ),
        );
        // debugPrint('scanning match');
        // debugPrint('scanning match startIndex:');
        // debugPrint(startIndex.toString());
        // debugPrint('scanning match endIndex:');
        // debugPrint(endIndex.toString());
        // debugPrint(text.substring(startIndex, endIndex));
        atIndex = endIndex;
      }
      if (!_scanner.isDone) {
        _scanner.position++;
      }
    }
    spans.add(TextSpan(text: text.substring(atIndex, (text.length - 1 > 0) ? text.length - 1 : 0)));
    debugPrint('build TextSpan successfully');
    return TextSpan(
      children: spans,
    );
  }
}