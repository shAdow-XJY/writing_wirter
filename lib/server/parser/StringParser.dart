import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

class StringParser {
  late final String content;
  late final StringScanner _scanner;

  StringParser(this.content) {
    _scanner = StringScanner(content);
  }

  final List<SpanBean> _spans = [];

  InlineSpan parser() {
    parseContent();

    final List<TextSpan> spans = <TextSpan>[];

    int currentPosition = 0;

    for (SpanBean span in _spans) {
      if (currentPosition != span.start) {
        spans.add(TextSpan(text: content.substring(currentPosition, span.start)));
      }
      spans.add(TextSpan(style: span.style, text: span.text(content)));
      currentPosition = span.end;
    }
    if (currentPosition != content.length) {
      spans.add(TextSpan(text: content.substring(currentPosition, content.length)));
    }
    return TextSpan(style: TextStyleSupport.defaultStyle, children: spans);
  }

  void parseContent() {
    while (!_scanner.isDone) {
      if (_scanner.scan(RegExp('`.*?`'))) {
        int startIndex = _scanner.lastMatch?.start ?? 0 ;
        int endIndex = _scanner.lastMatch?.end ?? 0;
        _spans.add(SpanBean(startIndex, endIndex));
      }
      if (!_scanner.isDone) {
        _scanner.position++;
      }
    }
  }
}

class SpanBean {
  SpanBean(this.start, this.end);

  final int start;
  final int end;

  String text(String src) {
    return src.substring(start+1, end-1);
  }

  TextStyle get style => TextStyleSupport.dotWrapStyle;
}

class TextStyleSupport{
  static const defaultStyle = TextStyle(color: Colors.black,fontSize: 14);
  static const dotWrapStyle = TextStyle(color: Colors.purple,fontSize: 14);
}