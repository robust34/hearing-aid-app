import 'dart:async';

import 'package:doceo_new/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimation createState() => _LoadingAnimation();
}

class _LoadingAnimation extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  String error = '';
  bool imageStatus = true;
  double scale = 1.1;
  late AnimationController _loadingController;
  late Animation<Color?> _colorAnimation;
  double size = 65;

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
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
                strokeWidth: 2.0, valueColor: _colorAnimation)));
  }
}
