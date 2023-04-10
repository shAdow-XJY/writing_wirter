# writing_writer
### some source code need to been change because of error log print
```
    D:\flutter\packages\flutter\lib\src\rendering\editable.dart
    
    if (_semanticsInfo!.any((InlineSpanSemanticsInformation info) => info.recognizer != null) &&
        defaultTargetPlatform != TargetPlatform.macOS) {
          assert(readOnly && !obscureText);
          
    =>
    
    if (_semanticsInfo!.any((InlineSpanSemanticsInformation info) => info.recognizer != null) &&
        defaultTargetPlatform != TargetPlatform.macOS) {
      // assert(readOnly && !obscureText);
```