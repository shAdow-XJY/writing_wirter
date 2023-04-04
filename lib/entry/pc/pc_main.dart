import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:writing_writer/router/pc/pc_router.dart';
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
            initTheme: ThemeData(
              // Colors
              primarySwatch: Colors.deepPurple,
              primaryColor: Colors.deepPurple[500],
              canvasColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              dividerColor: Colors.grey[400],
              disabledColor: Colors.grey[600],
              highlightColor: Colors.purple[100],
              splashColor: Colors.purpleAccent[100],
              appBarTheme: AppBarTheme(
                color: Colors.deepPurpleAccent[100],
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                actionsIconTheme: const IconThemeData(color: Colors.white),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),

              // Gradient
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                primaryColorDark: Colors.deepPurple[700],
                accentColor: Colors.purpleAccent,
                backgroundColor: Colors.white,
                cardColor: Colors.white,
                errorColor: Colors.red[900],
              ).copyWith(
                secondary: Colors.deepPurple[50],
                background: Colors.deepPurpleAccent[100],
              ),
            ),
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
