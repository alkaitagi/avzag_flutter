import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

void showDangerDialog(
  BuildContext context,
  VoidCallback onConfirm,
  String title, {
  IconData confirmIcon = Icons.delete_forever_outlined,
  String confirmText = 'Delete',
  IconData rejectIcon = Icons.edit_outlined,
  String rejectText = 'Keep',
}) async {
  final result = await context.router.pushNativeRoute<bool>(
    DialogRoute(
      context: context,
      builder: (context) {
        final theme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton.icon(
              onPressed: () => context.maybePop(true),
              icon: Icon(confirmIcon),
              label: Text(confirmText),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(theme.error),
                overlayColor: MaterialStateProperty.all(
                  theme.error.withOpacity(0.1),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: context.maybePop,
              icon: Icon(rejectIcon),
              label: Text(rejectText),
            ),
          ],
        );
      },
    ),
  );
  if (result == true) onConfirm();
}
