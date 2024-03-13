import 'package:flutter/material.dart';

class OptionItem {
  late final Widget? widget;
  final VoidCallback? onTap;

  OptionItem(
    this.widget, {
    this.onTap,
  });

  OptionItem.simple(
    IconData icon,
    String text, {
    this.onTap,
    bool centered = false,
  }) : widget = Row(
          mainAxisAlignment:
              centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            const SizedBox(width: 16),
            Icon(icon),
            const SizedBox(width: 16),
            Text(text),
            const SizedBox(width: 16),
          ],
        );

  OptionItem.tile(
    Widget leading,
    Widget title, {
    this.onTap,
  }) : widget = Row(
          children: [
            const SizedBox(width: 16),
            leading,
            const SizedBox(width: 16),
            title,
            const SizedBox(width: 16),
          ],
        );

  OptionItem.divider()
      : widget = null,
        onTap = null;
}

class OptionsButton extends StatelessWidget {
  const OptionsButton(
    this.options, {
    this.icon = const Icon(Icons.more_vert_outlined),
    this.tooltip,
    super.key,
  });

  final Widget icon;
  final String? tooltip;
  final List<OptionItem> options;

  PopupMenuEntry<int> _getMenuEntry(int i) {
    final w = options[i].widget;
    if (w == null) return const PopupMenuDivider();
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      value: i,
      child: w,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      data: const ListTileThemeData(horizontalTitleGap: 0),
      child: PopupMenuButton<int>(
        icon: icon,
        tooltip: tooltip,
        onSelected: (i) => options[i].onTap?.call(),
        itemBuilder: (context) {
          return [
            for (var i = 0; i < options.length; i++) _getMenuEntry(i),
          ];
        },
      ),
    );
  }
}
