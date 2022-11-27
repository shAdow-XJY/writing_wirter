import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

class StringParser {
  String _content;
  late StringScanner _scanner;
  
  Map<String, Set<String>> _currentParser;
  final List<SpanBean> _spans = [];
  InlineSpan inlineSpan = const TextSpan();
  
  TapGestureRecognizer ?_onTap;

  /// 构造函数
  StringParser(this._content, this._currentParser) {
    _scanner = StringScanner(_content);
    _parser();
  }

  /// 离开函数
  void dispose() {
    _onTap?.dispose();
  }

  void resetContent(String content) {
    _content = content;
    _scanner = StringScanner(_content);
    _parser();
  }

  void resetParser(Map<String, Set<String>> currentParser) {
    _currentParser = currentParser;
    _parser();
  }

  /// 点击事件
  void addOnTapEvent(VoidCallback onTap) {
    _onTap = TapGestureRecognizer()..onTap = onTap;
  }

  /// 正则匹配位置传入_spans
  void _parseContent() {
    _spans.clear();
    while (!_scanner.isDone) {
      _currentParser.forEach((setName, settingNameList) {
        for (var settingName in settingNameList) {
          if (_scanner.scan(RegExp(settingName))) {
            int startIndex = _scanner.lastMatch?.start ?? 0 ;
            int endIndex = _scanner.lastMatch?.end ?? 0;
            _spans.add(SpanBean(startIndex, endIndex));
          }
        }
      });
      if (!_scanner.isDone) {
        _scanner.position++;
      }
    }
  }

  /// 得到parser结果
  void _parser() {
    _parseContent();

    final List<TextSpan> spans = <TextSpan>[];
    int currentPosition = 0;

    for (SpanBean span in _spans) {
      if (currentPosition != span.start) {
        spans.add(TextSpan(text: _content.substring(currentPosition, span.start), recognizer: _onTap));
      }
      spans.add(TextSpan(style: span.style, text: span.text(_content)));
      currentPosition = span.end;
    }
    if (currentPosition != _content.length) {
      spans.add(TextSpan(text: _content.substring(currentPosition, _content.length)));
    }

    inlineSpan = TextSpan(style: TextStyleSupport.defaultStyle, children: spans);
  }

}

class SpanBean {
  SpanBean(this.start, this.end);

  final int start;
  final int end;

  String text(String src) {
    return src.substring(start, end);
  }

  TextStyle get style => TextStyleSupport.dotWrapStyle;
}

class TextStyleSupport{
  static const defaultStyle = TextStyle(color: Colors.black,fontSize: 14);
  static const dotWrapStyle = TextStyle(color: Colors.purple,fontSize: 14);
}