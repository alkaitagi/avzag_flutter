import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';

class ColumnCard extends StatelessWidget {
  const ColumnCard({
    required this.children,
    this.title,
    this.subtitle,
    this.elevation,
    this.divider = const Divider(),
    this.margin = const EdgeInsets.only(top: 12),
    this.padding = EdgeInsets.zero,
    this.shape = const RoundedRectangleBorder(),
    super.key,
  });

  final EdgeInsets margin;
  final EdgeInsets padding;
  final double? elevation;
  final ShapeBorder? shape;
  final String? title;
  final String? subtitle;
  final Widget? divider;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Card(
      elevation: elevation,
      margin: margin,
      shape: shape,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || subtitle != null) ...[
              const SizedBox(height: 8),
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    title!,
                    style: theme.bodyLarge,
                  ),
                ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Text(
                    subtitle!,
                    style: theme.bodyMedium,
                  ),
                ),
              const SizedBox(height: 12),
            ],
            ...divider == null || children.isEmpty
                ? children
                : intersperse(divider!, children)
          ],
        ),
      ),
    );
  }
}
