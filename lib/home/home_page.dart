import 'package:avzag/global_store.dart';
import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/span_icon.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'language_card.dart';
import 'languages_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _LanguageOrdering {
  final bool descending;
  final String text;
  final IconData? icon;
  late final String field;

  _LanguageOrdering(
    this.text, {
    this.icon,
    String? field,
    this.descending = false,
  }) {
    this.field = field ?? text;
  }
}

class _HomePageState extends State<HomePage> {
  var catalogue = <Language>[];
  var tags = <String, String>{};
  var languages = <Language>[];
  var selected = <Language>{};

  final inputController = TextEditingController();
  var isLoading = false;
  var isMap = false;

  final orderings = [
    _LanguageOrdering('name', icon: Icons.label_rounded),
    _LanguageOrdering('family', icon: Icons.public_rounded),
    null,
    _LanguageOrdering(
      'dictionary',
      icon: Icons.book_rounded,
      field: 'stats.dictionary',
      descending: true,
    ),
  ];
  late var ordering = orderings.first!;

  late final Future<void> loader;
  final chipsScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    inputController.addListener(filterLanguages);
    load();
  }

  Future load() async {
    setState(() {
      isLoading = true;
    });
    var query = FirebaseFirestore.instance
        .collection('languages')
        .orderBy(ordering.field, descending: ordering.descending);
    if (ordering.field != 'name') query = query.orderBy('name');

    catalogue = await query
        .withConverter(
          fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
          toFirestore: (Language language, _) => language.toJson(),
        )
        .get()
        .then((r) => r.docs.map((d) => d.data()).toList());

    selected = GlobalStore.languages.keys
        .map((n) => catalogue.firstWhere((l) => l.name == n))
        .toSet();
    tags = {
      for (var l in catalogue)
        l.name: [
          l.name,
          ...l.family ?? [],
          ...l.tags ?? [],
        ].join(' ')
    };

    isLoading = false;
    filterLanguages();
  }

  void filterLanguages() {
    if (isLoading) return;
    final query = inputController.text
        .trim()
        .toLowerCase()
        .split(' ')
        .where((s) => s.isNotEmpty);
    setState(() {
      languages
        ..clear()
        ..addAll(
          query.isEmpty
              ? catalogue
              : catalogue.where((l) {
                  final t = tags[l.name]!;
                  return query.any((q) => t.contains(q));
                }),
        );
    });
  }

  void toggleLanguage(Language language) {
    final has = selected.contains(language);
    setState(() {
      if (has) {
        selected.remove(language);
      } else {
        selected.add(language);
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => chipsScroll.animateTo(
            chipsScroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selected.isEmpty) {
            return showSnackbar(
              context,
              text: 'Select at least one language.',
            );
          }
          await showLoadingDialog(
            context,
            GlobalStore.load(
              selected.map((s) => s.name).toList(),
            ),
          );
          navigate(context);
        },
        tooltip: 'Continue',
        child: const Icon(Icons.done_all_rounded),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: true,
        title: selected.isEmpty
            ? Text(
                'Select languages below',
                style: Theme.of(context).textTheme.bodyText1,
              )
            : SizedBox(
                height: kToolbarHeight,
                child: ListView(
                  controller: chipsScroll,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        selected.clear();
                      }),
                      icon: const Icon(Icons.cancel_rounded),
                      tooltip: 'Unselect all',
                    ),
                    const SizedBox(width: 18),
                    for (final language in selected)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: InputChip(
                          avatar: LanguageAvatar(
                            language.flag,
                            radius: 12,
                          ),
                          label: Text(
                            capitalize(language.name),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () => setState(() {
                            selected.remove(language);
                          }),
                        ),
                      ),
                  ],
                ),
              ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: isMap ? 'Show list' : 'Show map',
                  icon: Icon(
                    isMap ? Icons.view_list_rounded : Icons.map_rounded,
                  ),
                  onPressed: () => setState(() {
                    isMap = !isMap;
                  }),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 8),
                    child: TextField(
                      controller: inputController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Search by names, tags, families',
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    return Badge(
                      ignorePointer: true,
                      animationType: BadgeAnimationType.fade,
                      position: BadgePosition.bottomStart(),
                      badgeColor: Theme.of(context).colorScheme.primary,
                      badgeContent: SpanIcon(
                        ordering.icon!,
                        color: Theme.of(context).colorScheme.onPrimary,
                        padding: EdgeInsets.zero,
                      ),
                      child: PopupMenuButton<_LanguageOrdering>(
                        icon: const Icon(Icons.filter_alt_rounded),
                        tooltip: 'Order by',
                        onSelected: (value) {
                          ordering = value;
                          load();
                        },
                        itemBuilder: (context) {
                          return [
                            for (final ordering in orderings)
                              if (ordering == null)
                                const PopupMenuDivider(height: 0)
                              else
                                PopupMenuItem(
                                  value: ordering,
                                  child: ListTile(
                                    leading: Icon(ordering.icon),
                                    title: Text(
                                      capitalize(ordering.text),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    selected: this.ordering == ordering,
                                  ),
                                )
                          ];
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (isMap) {
            return LanguagesMap(
              onToggle: toggleLanguage,
              selected: selected,
              languages: languages,
            );
          }
          return ListView.separated(
            itemCount: languages.length,
            padding: const EdgeInsets.only(top: 12, bottom: 76),
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final language = languages[index];
              return LanguageCard(
                language,
                selected: selected.contains(language),
                onTap: () => toggleLanguage(language),
              );
            },
          );
        },
      ),
    );
  }
}
