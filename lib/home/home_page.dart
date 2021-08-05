import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<String> selected;
  late final Map<String, String> tags;
  final inputController = TextEditingController();
  final List<Language> languages = [];

  @override
  void initState() {
    super.initState();
    selected = List.from(BaseStore.languages);
    tags = Map.fromIterable(
      HomeStore.languages.values,
      key: (l) => l.name,
      value: (l) => [
        l.name,
        ...l.family ?? [],
        ...l.tags ?? [],
      ].join(' '),
    );
    inputController.addListener(filterLanguages);
    filterLanguages();
  }

  @override
  void dispose() {
    BaseStore.languages = selected.toList();
    super.dispose();
  }

  void filterLanguages() {
    final query =
        inputController.text.trim().split(' ').where((s) => s.isNotEmpty);
    setState(() {
      languages
        ..clear()
        ..addAll(
          query.isEmpty
              ? HomeStore.languages.values
              : HomeStore.languages.values.where((l) {
                  final t = tags[l.name]!;
                  return query.any((q) => t.contains(q));
                }),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                await BaseStore.load(
                  context,
                  languages: selected,
                );
                await navigate(context, null);
              },
              icon: Icon(Icons.arrow_back_outlined),
              label: Text('Continue'),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            forceElevated: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            centerTitle: true,
            title: selected.isEmpty
                ? Text(
                    'Select languages below',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  )
                : Container(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 2),
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            selected.clear();
                          }),
                          icon: Icon(Icons.cancel_outlined),
                          tooltip: 'Unselect all',
                        ),
                        for (final language in selected) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: InputChip(
                              avatar: LanguageAvatar(
                                language,
                                radius: 12,
                              ),
                              label: Text(
                                capitalize(language),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () => setState(() {
                                selected.remove(language);
                              }),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(59),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Toggle map',
                    icon: Icon(Icons.map_outlined),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('The map comes soon'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 8),
                      child: TextField(
                        controller: inputController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Search by names, tags, families",
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: inputController.text.isEmpty
                        ? null
                        : inputController.clear,
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 64),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final language = languages[index];
                  final name = language.name;
                  final selected = this.selected.contains(name);
                  return LanguageCard(
                    language,
                    selected: selected,
                    onTap: () => setState(
                      () => selected
                          ? this.selected.remove(name)
                          : this.selected.add(name),
                    ),
                  );
                },
                childCount: languages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
