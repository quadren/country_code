import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sprung/sprung.dart';

abstract class AurumDialogSize {
  static const small = 0.25;
  static const medium = 0.4;
  static const large = 0.5;
  static const chungus = 0.66;
}

class AuDialog extends StatefulWidget {
  final Widget child;
  final double height;
  const AuDialog({required this.child, required this.height, Key? key})
      : super(key: key);

  @override
  _AuDialogState createState() => _AuDialogState();
}

class _AuDialogState extends State<AuDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  Tween<double> tween = Tween(begin: 0.0, end: 1.0);

  void animate() {
    controller =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    animation = tween.animate(
        CurvedAnimation(parent: controller!, curve: Sprung.criticallyDamped))
      ..addListener(() {
        setState(() {});
      });

    controller?.forward();
  }

  @override
  void initState() {
    super.initState();
    animate();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = Theme.of(context).colorScheme.background;

    const BorderRadius rad = BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22));

    return Transform.scale(
        scale: animation == null ? 0 : animation!.value,
        child: OrientationBuilder(builder: (context, or) {
          return ResponsiveBuilder(builder: (context, si) {
            final double height = si.screenSize.height;
            final double width = si.screenSize.width;

            bool l = or == Orientation.landscape;

            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: l ? width * 0.22 : width * 0.085),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: rad,
                  ),
                  child: Container(
                      height: height * widget.height + (l ? height * 0.15 : 0),
                      width: width,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: rad,
                      ),
                      child: ClipRRect(
                        borderRadius: rad,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: l ? width * 0.03 : width * 0.05,
                                vertical: l ? height * 0.03 : width * 0.05),
                            child: widget.child),
                      )),
                ),
              ),
            );
          });
        }));
  }
}
