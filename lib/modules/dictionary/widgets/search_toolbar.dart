import 'dart:async';

import 'package:bazur/shared/extensions.dart';
import 'package:bazur/shared/widgets/language_avatar.dart';
import 'package:bazur/shared/widgets/options_button.dart';
import 'package:bazur/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/algolia_search_controller.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({super.key});

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  final _input = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String lastText = '';

  @override
  void initState() {
    super.initState();
    _input.addListener(() {
      if (lastText == _input.text) return;
      setState(() {
        lastText = _input.text;
      });
      timer.cancel();
      if (_input.text.isEmpty) {
        search();
      } else {
        timer = Timer(
          const Duration(milliseconds: 300),
          search,
        );
      }
    });
    Timer(
      const Duration(milliseconds: 300),
      search,
    );
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void search() => context.read<AlgoliaSearchController>().query(_input.text);

  void setLanguage(String language) {
    context.read<AlgoliaSearchController>().setLanguage(language);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<AlgoliaSearchController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 4),
        OptionsButton(
          [
            OptionItem.simple(
              Icons.language_outlined,
              'Global',
              onTap: () => setLanguage(''),
            ),
            OptionItem.divider(),
            for (final l in GlobalStore.languages)
              OptionItem.tile(
                Transform.scale(
                  scale: 1.25,
                  child: LanguageAvatar(
                    l,
                    radius: 12,
                  ),
                ),
                Text(
                  l.titled,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => setLanguage(l),
              ),
          ],
          tooltip: 'Search mode',
          icon: search.language.isEmpty
              ? const Icon(Icons.language_outlined)
              : LanguageAvatar(search.language),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Builder(
            builder: (context) {
              var label = 'Search ';
              label += search.global
                  ? 'forms in ${search.language.titled}'
                  : '${search.language.isEmpty ? 'over' : 'across'} the languages';
              return TextField(
                controller: _input,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 4),
        if (_input.text.isNotEmpty)
          IconButton(
            onPressed: _input.clear,
            tooltip: 'Clear',
            icon: const Icon(Icons.clear_outlined),
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}
