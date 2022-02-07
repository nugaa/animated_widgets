import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BoxAnimated extends StatefulWidget {
  const BoxAnimated({Key? key}) : super(key: key);

  @override
  _BoxAnimatedState createState() => _BoxAnimatedState();
}

class _BoxAnimatedState extends State<BoxAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _openBox = false;
  final PageController _pageController = PageController();
  double? top = 50;
  double? left = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  Future _playAnimation(int page) async {
    try {
      if (!_animationController.isAnimating) {
        _animationController
            .forward()
            .orCancel
            .whenComplete(() => _animationController.reverse().orCancel);
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
    return Scaffold(
        body: Stack(
      children: [
        PageView.builder(
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            onPageChanged: (page) {
              setState(() {
                _openBox = !_openBox;
              });
              _playAnimation(page);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget? child) => AnimateBox(
                  animationController: _animationController.view,
                ),
              );
            }),
        Positioned(
          top: top,
          left: left,
          child: Draggable(
            childWhenDragging: Container(),
            onDragEnd: (dragDetails) {
              setState(() {
                top = dragDetails.offset.dy;
                left = dragDetails.offset.dx;
              });
            },
            feedback: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

class AnimateBox extends StatelessWidget {
  AnimateBox({required Animation<double> animationController, Key? key})
      : top = Tween<double>(begin: 320, end: 150).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        vector = Tween<double>(begin: -0.0003, end: -0.001).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        testY = Tween<double>(begin: 0, end: 0).animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.150, 0.500, curve: Curves.ease))),
        colors = ColorTween(begin: Colors.white, end: Colors.lightBlue).animate(
            CurvedAnimation(
                parent: animationController,
                curve: Curves.fastLinearToSlowEaseIn)),
        tampaHeight = Tween<double>(begin: 245, end: 50).animate(
            CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.150, 0.500, curve: Curves.ease))),
        tampaWidth = Tween<double>(begin: 305, end: 305).animate(
            CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.150, 0.500, curve: Curves.ease))),
        super(key: key);

  final Animation<double> top;
  final Animation<double> vector;
  final Animation<double> testY;
  final Animation<Color?> colors;
  final Animation<double> tampaHeight;
  final Animation<double> tampaWidth;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    timeDilation = 4;
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              border: Border.all(width: 2.0, color: Colors.black),
            ),
            height: 200,
            width: 300,
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(width: 1.0, color: Colors.black),
            ),
            height: 160,
            width: 260,
          ),
        ),
        Positioned(
          top: height / 2.7,
          left: width / 9.1,
          child: Transform.translate(
            offset: Offset(0, testY.value),
            child: Transform(
              origin: const Offset(0, -80),
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 1, vector.value)
                ..rotateX(-math.pi * -.2),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    border: Border.all(
                      color: Colors.black87,
                      width: 1,
                    )),
                height: tampaHeight.value,
                width: tampaWidth.value,
                child: Text(
                  'NIKE',
                  style: TextStyle(
                      color: colors.value,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
