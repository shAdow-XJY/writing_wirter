import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lottie/lottie.dart';
import 'package:redux/redux.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../redux/action/style_action.dart';
import '../../redux/app_state/state.dart';

class PrePage extends StatefulWidget {
  const PrePage({Key? key}) : super(key: key);

  @override
  State<PrePage> createState() => _PrePageState();
}

class _PrePageState extends State<PrePage> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ResponsiveBuilder 获取不同设备类型的信息
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return StoreConnector<AppState, AsyncCallback>(
        converter: (Store store) {
          return () async => {
                store.dispatch(SetStyleDataAction(
                    deviceScreenType: sizingInformation.deviceScreenType)),
              };
        },
        builder: (BuildContext context, AsyncCallback callback) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.5),
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(flex: 2, child: SizedBox()),
                Expanded(
                    flex: 2,
                    child: Text(
                      'Writing Writer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.none,
                          shadows: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.white.withOpacity(0.54)),
                          ],
                      ),
                    ),
                ),
                Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    'assets/anim/loading-book.json',
                    controller: _controller,
                    onLoaded: (composition) {
                      // Configure the AnimationController with the duration of the
                      // Lottie file and start the animation.
                      _controller.forward().whenComplete(
                            () => {
                              callback(),
                              Navigator.popAndPushNamed(context, '/homepage'),
                            },
                          );
                    },
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          );
        },
      );
    });
  }
}
