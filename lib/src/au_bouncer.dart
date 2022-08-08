import 'package:flutter/material.dart';

class AuBouncer extends StatefulWidget {
  const AuBouncer({required this.child, required this.onClick});

  final Widget child;
  final VoidCallback? onClick;

  @override
  _AuBouncerState createState() => _AuBouncerState();
}

class _AuBouncerState extends State<AuBouncer>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation? animation;
  Tween<double> tween = Tween(begin: 1, end: 0.92);

  bool hovered = false;

  void initAnim() {
    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 35),
        reverseDuration: Duration(milliseconds: 300));
    animation = tween.animate(CurvedAnimation(
        parent: animationController!,
        curve: Curves.linear,
        reverseCurve: Curves.elasticIn))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void initState() {
    initAnim();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          animationController?.forward();
        },
        onTapUp: (TapUpDetails details) {
          animationController?.reverse();
          widget.onClick?.call();
        },
        child: Transform.scale(
          scale: animation?.value ?? 1,
          child: widget.child,
        ),
      ),
    );
  }
}
