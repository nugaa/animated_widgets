import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedRadioButton extends StatelessWidget {
  AnimatedRadioButton({required Animation<double> animation, Key? key})
      : backgroundColor = ColorTween(
          begin: const Color(0xff3e3e3e),
          end: const Color(0xe8ffffff),
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuad)),
        position = Tween<double>(
          begin: -30,
          end: 25,
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        width = Tween<double>(
          begin: 30,
          end: 10,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        angle = Tween<double>(
          begin: -pi,
          end: pi * 2,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        buttonColor = ColorTween(
          begin: const Color(0xe8ffffff),
          end: const Color(0xff3e3e3e),
        ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuad)),
        super(key: key);

  final Animation<Color?> backgroundColor;
  final Animation<double> position;
  final Animation<double> width;
  final Animation<double> angle;
  final Animation<Color?> buttonColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2.0),
          width: 100,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor.value,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black38, width: 2),
          ),
        ),
        Transform.translate(
            offset: Offset(position.value, 0),
            child: Transform.rotate(
              angle: angle.value,
              child: Container(
                width: width.value,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: buttonColor.value,
                ),
              ),
            )),
      ],
    );
  }
}

class RadioButton extends StatefulWidget {
  const RadioButton({Key? key}) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool _trigger = false;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future _playAnimation() async {
    if (!_trigger) {
      await animationController.forward();
    } else {
      await animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;
    return FittedBox(
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => GestureDetector(
              onTap: () {
                setState(() {
                  _trigger = !_trigger;
                });
                _playAnimation();
              },
              child: AnimatedRadioButton(animation: animationController.view))),
    );
  }
}
