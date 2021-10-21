import 'package:flutter/material.dart';

class RaxysLogo extends StatelessWidget {
  const RaxysLogo({
    this.size = 24,
    this.opacity = 1,
    this.scale = 1,
    Key? key,
  }) : super(key: key);

  final double scale;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/splash_dark.png'
                : 'assets/splash_light.png',
            isAntiAlias: true,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
