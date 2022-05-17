import 'package:avzag/shared/widgets/snackbar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void copyText(BuildContext context, String? text) async {
  if (text?.isNotEmpty ?? false) {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    showSnackbar(
      context,
      icon: Icons.content_copy_outlined,
      text: 'Copied to clipboard.',
    );
  }
}
