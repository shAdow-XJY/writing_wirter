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

```
    C:\Users\12902\AppData\Local\Pub\Cache\hosted\pub.dev\webdav_client-1.2.0\lib\src\webdav_dio.dart
    
    completer.completeError(DioMixin.assureDioError(
        e,
        resp.requestOptions,
        trace,
    ));
    
    =>
    
    completer.completeError(DioMixin.assureDioError(
        e,
        resp.requestOptions,
    ));
```