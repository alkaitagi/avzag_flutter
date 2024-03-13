import 'package:flutter/material.dart';

import 'span_icon.dart';

class Caption extends StatelessWidget {
  const Caption(
    this.text, {
    this.icon,
    this.padding = const EdgeInsets.all(16),
    this.centered = true,
    super.key,
  });

  final String text;
  final IconData? icon;
  final EdgeInsets padding;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment:
            centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (icon != null)
            SpanIcon(
              icon!,
              padding: const EdgeInsets.only(right: 4),
            ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
