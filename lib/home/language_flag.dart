import 'dart:math';
import 'package:avzag/home/language.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  final Language language;
  final double width;
  final double height;
  final bool circle;
  final double rotation;
  final Offset offset;
  final double scale;

  const LanguageFlag(
    this.language, {
    this.width = 16,
    this.height = 4,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 18,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: Image.network(
              language.flagUrl,
              repeat: ImageRepeat.repeatX,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) =>
                  Container(),
            ),
          ),
        ),
      ),
    );
  }
}
