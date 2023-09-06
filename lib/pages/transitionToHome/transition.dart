import 'dart:async';

import 'package:doceo_new/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({super.key});

  @override
  _TransitionPage createState() => _TransitionPage();
}

class _TransitionPage extends State<TransitionPage>
    with TickerProviderStateMixin {
  String error = '';
  bool imageStatus = true;
  double scale = 1.1;
  late AnimationController _loadingController;
  late Animation<Color?> _colorAnimation;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: const Color(0xff5200FF),
      end: const Color(0xffDB00FF),
    ).animate(_loadingController);
    _colorAnimation.addListener(() => setState(() {}));
    _loadingController.repeat();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        imageStatus = !imageStatus;
      });
      _gradientController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 1000,
        ),
      );
      _gradientController.addListener(() {
        if (_gradientController.value == 1) {
          // context.go('/home');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {}
      });
      _gradientController.forward();
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
    _gradientController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: imageStatus
                  ? SizedBox(
                      height: 66,
                      width: 66,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0, valueColor: _colorAnimation))
                  : Opacity(
                      opacity: 1,
                      child: Center(
                          child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 4 *
                                ((_gradientController.value - 0.5).abs() - 0.5)
                                    .abs(),
                            colors: const [
                              Color.fromRGBO(163, 22, 199, 0.69),
                              Color.fromRGBO(0, 224, 255, 0.01),
                            ],
                            stops: const [0.2448, 1.0],
                          ),
                        ),
                      )),
                    )),
        ),
        onWillPop: () => Future.value(false));
  }
}
