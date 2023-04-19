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
    \Local\Pub\Cache\hosted\pub.dev\animated_stack-0.2.0\lib\animated_stack.dart
    
    class AnimatedStack 
      
    => add onChanged Function
    
    widget.onChanged(opened),
```