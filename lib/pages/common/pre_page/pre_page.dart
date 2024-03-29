import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../components/common/toast/global_toast.dart';

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
    _controller = AnimationController(duration: const Duration(milliseconds: 2500), vsync: this);
    GlobalToast.init(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    Navigator.popAndPushNamed(context, '/home'),
                  },
                );
              },
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }
}
