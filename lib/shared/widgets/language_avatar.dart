import 'package:flutter/material.dart';

class LanguageAvatar extends StatelessWidget {
  final String? language;
  final double? radius;

  const LanguageAvatar(
    this.language, {
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: NetworkImage(
        'https://firebasestorage.googleapis.com/v0/b/avzagapp.appspot.com/o/flags%2F$language.png?alt=media',
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
