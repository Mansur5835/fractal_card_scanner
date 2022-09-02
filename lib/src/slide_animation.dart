import 'package:flutter/material.dart';

typedef Widget ControllerFunc(AnimationController animatedContainer);

late AnimationController _controller;

class FractalSlideController {
  static AnimationController getController({required TickerProvider vsync}) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );
    return _controller;
  }
}

extension AddUff on AnimationController {
  Widget buildWidget({required ControllerFunc child}) {
    return _FratalSlideAnimation(
      child: child(this),
    );
  }
}

class _FratalSlideAnimation extends StatefulWidget {
  Widget child;

  _FratalSlideAnimation({Key? key, required this.child}) : super(key: key);

  @override
  State<_FratalSlideAnimation> createState() => _FratalSlideAnimationState();
}

class _FratalSlideAnimationState extends State<_FratalSlideAnimation>
    with TickerProviderStateMixin {
  late Animation<Offset> offset;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    offset = Tween<Offset>(
      begin: const Offset(0, 5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: offset, child: widget.child);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
}
