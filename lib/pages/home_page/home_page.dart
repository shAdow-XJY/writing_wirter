import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// 输入框控制器
  late final TextEditingController textEditingController;

  /// 输入框的内容
  String controllerText = "";
  
  @override
  void initState() {
    super.initState();

    ///控制 初始化的时候光标保持在文字最后
    textEditingController = TextEditingController.fromValue(
      ///用来设置初始化时显示
      TextEditingValue(
        ///用来设置文本 controller.text = "0000"
        text: controllerText,
        ///设置光标的位置
        selection: TextSelection.fromPosition(
          ///用来设置文本的位置
          TextPosition(
              affinity: TextAffinity.downstream,
              /// 光标向后移动的长度
              offset: controllerText.length
          ),
        ),
      ),
    );

    /// 添加兼听 当TextFeild 中内容发生变化时 回调 焦点变动 也会触发
    /// onChanged 当TextFeild文本发生改变时才会回调
    textEditingController.addListener((){
      ///获取输入的内容
      String currentStr = textEditingController.text;
      debugPrint(" controller 兼听 $currentStr");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('chapter name'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: screenSize.height / 10.0, horizontal: screenSize.width / 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                /// 消除下边框
                border: OutlineInputBorder(borderSide: BorderSide.none,),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}