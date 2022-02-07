import 'package:flutter/material.dart';

class BallWidget extends StatefulWidget {
  const BallWidget({required int? duration, Key? key})
      : _duration = duration,
        super(key: key);
  final int? _duration;
  @override
  _BallWidgetState createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    Future.delayed(Duration(milliseconds: widget._duration!))
        .then((value) async => await animationController.repeat(reverse: true));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return BallAnimation(animationController: animationController);
        });
  }
}

class BallAnimation extends StatelessWidget {
  BallAnimation({required Animation<double> animationController, Key? key})
      : position = Tween<double>(begin: 0, end: -8).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        )),
        colors = ColorTween(
          begin: Colors.grey,
          end: Colors.grey.withOpacity(0.3),
        ).animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease)),
        super(key: key);

  final Animation<double> position;
  final Animation<Color?> colors;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, position.value),
      child: Icon(
        Icons.circle,
        size: 10,
        color: colors.value,
      ),
    );
  }
}

class BallsIsTyping extends StatelessWidget {
  const BallsIsTyping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        BallWidget(
          duration: 0,
        ),
        BallWidget(
          duration: 300,
        ),
        BallWidget(
          duration: 500,
        ),
      ],
    );
  }
}
