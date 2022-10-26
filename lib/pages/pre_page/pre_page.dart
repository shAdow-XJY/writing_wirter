import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../redux/action/style_action.dart';
import '../../redux/app_state/state.dart';

class PrePage extends StatefulWidget {
  const PrePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PrePage> createState() => _PrePageState();
}

class _PrePageState extends State<PrePage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const timeout = Duration(seconds: 6);
    Timer(timeout, () {
      Navigator.of(context).popAndPushNamed('/homepage');
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ResponsiveBuilder 获取不同设备类型的信息
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return StoreConnector<AppState, void>(
            converter: (Store store) {
              store.dispatch(SetStyleDataAction(deviceScreenType: sizingInformation.deviceScreenType));
            },
            builder: (BuildContext context, void nothing) {
              return const SizedBox();
            },
        );
      },
    );
  }
}
