import 'package:avzag/widgets/column_tile.dart';
import 'package:flutter/material.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final EdgeInsetsGeometry padding;

  NoteDisplay(
    this.note, {
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return note == null
        ? Offstage()
        : ColumnTile(
            Text(
              note!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            leading: Icon(Icons.info_outline),
          );
  }
}
