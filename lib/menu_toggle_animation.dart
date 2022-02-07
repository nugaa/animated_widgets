import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedMenuButton extends StatelessWidget {
  AnimatedMenuButton({required Animation<double> animation, Key? key})
      : width = Tween<double>(
          begin: 50,
          end: 300,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        icon = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.5, 1, curve: Curves.ease))),
        super(key: key);

  final Animation<double> width;
  final Animation<double> icon;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: width.value < 60 ? Alignment.center : Alignment.centerLeft,
      height: 50,
      width: width.value,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.black54,
      ),
      child: Row(
        mainAxisAlignment: width.value < 60
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          AnimatedIcon(
            progress: icon,
            color: Colors.white,
            icon: AnimatedIcons.menu_close,
          ),
          width.value < 260
              ? const SizedBox()
              : Opacity(
                  opacity: opacity.value,
                  child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: () => print('item$index'),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
        ],
      ),
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future _playAnimation() async {
    if (_isExpanded) {
      await animationController.forward();
    } else {
      await animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                  _playAnimation();
                },
                child: AnimatedMenuButton(
                  animation: animationController.view,
                ),
              )),
    );
  }
}
