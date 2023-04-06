import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/router/pc/pc_router.dart';
import 'package:writing_writer/service/theme/theme.dart';
import '../../state_machine/redux/app_state/state.dart';

class PcApp extends StatelessWidget {
  PcApp({Key? key}) : super(key: key);

  final store = Store<AppState>(appReducer, initialState: AppState.initialState());

  @override
  Widget build(BuildContext context) {
    /// 使用StoreProvider 包裹根元素，使其提供store
    return StoreProvider(
      store: store,
      /// 为了能直接在child使用store，我们这里要继续包裹一层StoreBuilder
      child: StoreBuilder<AppState>(
        builder: (context, store) {
          return ThemeProvider(
            initTheme: blueTheme,
            builder: (context, myTheme) {
              return MaterialApp(
                  title: 'Writing Writer',
                  theme: myTheme,
                  debugShowCheckedModeBanner: false,
                  initialRoute: '/',
                  onGenerateRoute: pcGenerateRoute
              );
            },
          );
        },
      ),
    );
  }
}
