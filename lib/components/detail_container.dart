import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../redux/app_state/state.dart';

class DetailContainer extends StatefulWidget {
  const DetailContainer({Key? key,}) : super(key: key);

  @override
  State<DetailContainer> createState() => _DetailContainerState();
}

class _DetailContainerState extends State<DetailContainer>{
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (Store store) {
        return store.state.ioBase.getSettingContent(
          store.state.textModel.currentBook,
          store.state.setModel.currentSet,
          store.state.setModel.currentSetting,
        );
      },
      builder: (BuildContext context, String settingContent) {
        return Container(
          color: Theme.of(context).focusColor,
          child: Column(
            children: [
              Text(settingContent)
            ],
          ),
        );
      },
    );
  }

}