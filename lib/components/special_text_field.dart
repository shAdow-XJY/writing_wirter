import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';

class SpecialTextField extends StatefulWidget {
  final TextEditingController controller;
  Function(String)? callBack;
  RegExp? regExp;
  SpecialTextField({
    Key? key,
    required this.controller,
    this.callBack,
    this.regExp,
  }) : super(key: key);

  @override
  State<SpecialTextField> createState() => _SpecialTextFieldState();
}

class _SpecialTextFieldState extends State<SpecialTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetectableTextField(
      controller: widget.controller,
      maxLines: null,
      decoration: const InputDecoration(
        /// 消除下边框
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      detectionRegExp: RegExp(r'(人物A|人物a)'), //detectionRegExp() ?? RegExp('source'),
      decoratedStyle: TextStyle(
        fontSize: 20,
        color: Colors.blue,
      ),
      basicStyle: TextStyle(
        fontSize: 20,
      ),
      onTap: () {
        print('asdasdas');
      },
    );
  }
}

class OverTextEditingController extends TextEditingController{

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final atIndex = text.indexOf('@');
    var spans = <InlineSpan>[];

    if (atIndex != -1) {
      spans.add(TextSpan(text: text.substring(0, atIndex)));
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('@'),
            ),
          ),
        ),
      );
      spans.add(TextSpan(text: text.substring(1 + atIndex)));
    } else {
      spans.add(TextSpan(text: text));
    }

    return TextSpan(
      children: spans,
    );
  }
}