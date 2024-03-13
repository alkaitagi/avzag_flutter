import 'package:bazur/shared/extensions.dart';
import 'package:flutter/material.dart';

import 'language_flag.dart';

class LanguageTitle extends StatelessWidget {
  const LanguageTitle(
    this.language, {
    super.key,
  });

  final String language;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Opacity(
            opacity: .4,
            child: LanguageFlag(language),
          ),
        ),
        Text(language.titled),
      ],
    );
  }
}
