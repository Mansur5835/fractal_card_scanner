import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';

typedef Widget AnimationChild(double size);

class FractalHeartAnimation extends StatefulWidget {
  int? duration;
  AnimationChild animationChild;
  FractalHeartAnimation({Key? key, required this.animationChild, this.duration})
      : super(key: key);

  @override
  State<FractalHeartAnimation> createState() => _FractalHeartAnimationState();
}

class _FractalHeartAnimationState extends State<FractalHeartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controllerSize;
  late Animation<double> _animationSize;

  @override
  void initState() {
    super.initState();

    _controllerSize = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration ?? 1000));

    _animationSize = Tween<double>(begin: 16, end: 18).animate(
        CurvedAnimation(parent: _controllerSize, curve: Curves.bounceInOut));
    _controllerSize.forward();

    _controllerSize.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return widget.animationChild(_animationSize.value);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerSize.dispose();
  }
}
