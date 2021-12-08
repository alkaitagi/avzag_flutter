import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/utils/utils.dart';
import 'package:flutter/material.dart';
import 'editor_dialog.dart';

class TextSample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  TextSample(
    this.plain, {
    this.ipa,
    this.glossed,
    this.translation,
  });

  TextSample.fromJson(Map<String, dynamic> json)
      : this(
          json['plain'] as String,
          ipa: json['ipa'] as String?,
          glossed: json['glossed'] as String?,
          translation: json['translation'] as String?,
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['plain'] = plain;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    if (glossed?.isNotEmpty ?? false) data['glossed'] = glossed;
    if (translation?.isNotEmpty ?? false) data['translation'] = translation;
    return data;
  }
}

class TextSampleTiles extends StatefulWidget {
  final List<TextSample>? samples;
  final ValueSetter<List<TextSample>?>? onEdited;
  final String name;
  final IconData? icon;
  final bool translation;

  const TextSampleTiles({
    Key? key,
    this.samples,
    this.onEdited,
    this.icon,
    this.translation = false,
    this.name = 'sample',
  }) : super(key: key);

  @override
  _TextSampleTilesState createState() => _TextSampleTilesState();
}

class _TextSampleTilesState extends State<TextSampleTiles> {
  bool advanced = false;

  TextSpan getTextSpan(BuildContext context, int index) {
    final extended = advanced || widget.onEdited != null;
    final sample = widget.samples![index];
    final fields = [
      sample.translation,
      if (extended) ...[
        sample.ipa == null ? null : '/${sample.ipa}/',
        sample.glossed,
      ]
    ].where((t) => t != null);

    final theme = Theme.of(context).textTheme;
    return TextSpan(
      style: TextStyle(
        fontSize: theme.subtitle1?.fontSize,
        color: theme.caption?.color,
      ),
      children: [
        TextSpan(
          text: sample.plain,
          style: TextStyle(
            color: theme.bodyText2?.color,
          ),
        ),
        if (fields.isNotEmpty)
          TextSpan(
            text: ['', ...fields].join(' • '),
          )
      ],
    );
  }

  void showEditor(BuildContext context, int index) {
    final samples = widget.samples ?? [];
    final result = index < samples.length
        ? TextSample.fromJson(samples[index].toJson())
        : TextSample('');
    showEditorDialog<List<TextSample>>(
      context,
      result: () {
        if (index < samples.length) {
          samples[index] = result;
        } else {
          samples.add(result);
        }
        return samples;
      },
      callback: (result) {
        if (result == null && index < samples.length) samples.removeAt(index);
        widget.onEdited!.call(samples);
      },
      title: 'Edit ${widget.name}',
      children: [
        TextFormField(
          autofocus: true,
          initialValue: result.plain,
          onChanged: (value) => result.plain = value.trim(),
          decoration: const InputDecoration(
            labelText: 'Plain text',
          ),
          inputFormatters:
              widget.translation ? null : [LowerCaseTextFormatter()],
          validator: emptyValidator,
        ),
        TextFormField(
          initialValue: result.ipa,
          onChanged: (value) => result.ipa = value.trim(),
          decoration: const InputDecoration(
            labelText: 'IPA (glossed)',
          ),
          inputFormatters: [LowerCaseTextFormatter()],
        ),
        TextFormField(
          initialValue: result.glossed,
          onChanged: (value) => result.glossed = value.trim(),
          decoration: const InputDecoration(
            labelText: 'Leipzig-glossed',
          ),
        ),
        if (widget.translation)
          TextFormField(
            initialValue: result.translation,
            onChanged: (value) => result.translation = value.trim(),
            decoration: const InputDecoration(
              labelText: 'Translation',
            ),
          ),
      ],
    );
  }

  ListTile buildTile(BuildContext context, int index) {
    return ListTile(
      minVerticalPadding: 8,
      leading: Icon(
        widget.icon,
        color: index == 0 ? null : Colors.transparent,
      ),
      title: widget.samples?.isEmpty ?? true
          ? Text(
              'Tap to add ${widget.name}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.caption?.color,
              ),
            )
          : widget.onEdited == null
              ? SelectableText.rich(getTextSpan(context, index))
              : RichText(text: getTextSpan(context, index)),
      onTap: widget.onEdited == null ? null : () => showEditor(context, index),
      trailing: widget.onEdited == null || index > 0
          ? null
          : IconButton(
              onPressed: () => showEditor(
                context,
                widget.samples?.length ?? 0,
              ),
              icon: const Icon(Icons.add_rounded),
              tooltip: 'Add ${widget.name}',
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples == null && widget.onEdited == null) {
      return const Offstage();
    }
    if (widget.onEdited == null) {
      return ListTile(
        minVerticalPadding: 12,
        onTap: () => setState(() {
          advanced = !advanced;
        }),
        onLongPress: widget.onEdited == null
            ? () => copyText(
                  context,
                  widget.samples
                      ?.map(
                        (s) => [
                          s.plain,
                          if (s.translation != null) s.translation
                        ].join(' '),
                      )
                      .join('\n'),
                )
            : null,
        leading: Icon(widget.icon),
        title: RichText(
          text: TextSpan(
            children: [
              getTextSpan(context, 0),
              for (var i = 1; i < widget.samples!.length; i++) ...[
                const TextSpan(text: '\n'),
                getTextSpan(context, i),
              ],
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        buildTile(context, 0),
        if (widget.samples != null)
          for (var i = 1; i < widget.samples!.length; i++)
            buildTile(context, i),
      ],
    );
  }
}
