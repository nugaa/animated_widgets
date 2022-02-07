import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimateTest extends StatefulWidget {
  const AnimateTest({Key? key}) : super(key: key);

  @override
  _AnimateTestState createState() => _AnimateTestState();
}

class _AnimateTestState extends State<AnimateTest>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRight = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  Future _playAnimation() async {
    try {
      if (!_animationController.isAnimating) {
        // if (!_isRight) {
        //
        // }
        await _animationController.forward().orCancel;
        await _animationController.reverse();
      }
    } on TickerCanceled catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return GestureDetector(
              onTap: () {
                _playAnimation();
                setState(() {
                  _isRight = !_isRight;
                });
              },
              child: Stack(
                children: [
                  TestWidget(
                    animationController: _animationController.view,
                  ),
                  TestWidget2(
                    animationController: _animationController.view,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TestWidget extends StatelessWidget {
  TestWidget({required Animation<double> animationController, Key? key})
      : height = Tween<double>(
          begin: 75,
          end: 175,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        width = Tween<double>(
          begin: 75,
          end: 175,
        ).animate(
          CurvedAnimation(parent: animationController, curve: Curves.ease),
        ),
        colors = ColorTween(
          begin: Colors.red,
          end: Colors.lightBlueAccent,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        rotate = Tween<double>(
          begin: -pi * 2,
          end: pi * 4,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        borderRadius = Tween<double>(
          begin: 0.0,
          end: 85.0,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.linearToEaseOut)),
        alignment = Tween<Alignment>(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        textColor = ColorTween(
          begin: Colors.white,
          end: Colors.redAccent,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        super(key: key);

  final Animation<double> width;
  final Animation<double> height;
  final Animation<Color?> colors;
  final Animation<double> rotate;
  final Animation<double> borderRadius;
  final Animation<Alignment> alignment;
  final Animation<Color?> textColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment.value,
      child: Transform.rotate(
        angle: rotate.value,
        child: Container(
          alignment: Alignment.center,
          height: height.value,
          width: width.value,
          decoration: BoxDecoration(
            color: colors.value,
            borderRadius: BorderRadius.circular(borderRadius.value),
          ),
          child: Text(
            'Texto',
            style: TextStyle(
                fontSize: 18.0,
                color: textColor.value,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class TestWidget2 extends StatelessWidget {
  TestWidget2({required Animation<double> animationController, Key? key})
      : height = Tween<double>(
          begin: 75,
          end: 175,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        width = Tween<double>(
          begin: 75,
          end: 175,
        ).animate(
          CurvedAnimation(parent: animationController, curve: Curves.ease),
        ),
        colors = ColorTween(
          begin: Colors.red,
          end: Colors.lightBlueAccent,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        rotate = Tween<double>(
          begin: -pi * 2,
          end: pi * 4,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        borderRadius = Tween<double>(
          begin: 0.0,
          end: 85.0,
        ).animate(CurvedAnimation(
            parent: animationController, curve: Curves.linearToEaseOut)),
        alignment = Tween<Alignment>(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        textColor = ColorTween(
          begin: Colors.white,
          end: Colors.redAccent,
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        super(key: key);

  final Animation<double> width;
  final Animation<double> height;
  final Animation<Color?> colors;
  final Animation<double> rotate;
  final Animation<double> borderRadius;
  final Animation<Alignment> alignment;
  final Animation<Color?> textColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment.value,
      child: Transform.rotate(
        angle: rotate.value,
        child: Container(
          alignment: Alignment.center,
          height: height.value,
          width: width.value,
          decoration: BoxDecoration(
            color: colors.value,
            borderRadius: BorderRadius.circular(borderRadius.value),
          ),
          child: Text(
            'Texto',
            style: TextStyle(
                fontSize: 18.0,
                color: textColor.value,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
