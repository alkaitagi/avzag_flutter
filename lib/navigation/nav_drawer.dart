import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/expandable_tile.dart';
import 'package:avzag/widgets/raxys_logo.dart';
import 'package:avzag/widgets/span_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_page.dart';

Future<void> navigate(
  BuildContext context, [
  String? title,
]) async {
  final prefs = await SharedPreferences.getInstance();
  if (title == null) {
    title = prefs.getString('module');
    if (title == null || title == 'home') title = 'dictionary';
  }

  late Widget Function(BuildContext) builder;
  if (title == 'home') {
    builder = (_) => const HomePage();
    title = null;
  } else if (title == 'dictionary') {
    builder = (_) => const DictionaryPage();
  } else {
    builder = (_) => const Text("No Route");
  }

  if (title != null) await prefs.setString('module', title);
  await Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: builder),
  );
}

class _NavModule {
  final IconData icon;
  final String text;
  _NavModule(this.icon, this.text);

  Widget build(BuildContext context, [String? route]) {
    final enabled = route != null;
    return ListTile(
      leading: Icon(icon),
      title: Text(
        capitalize(text),
        style: const TextStyle(fontSize: 18),
      ),
      trailing: enabled ? null : const Icon(Icons.construction_rounded),
      selected: route == text,
      onTap: enabled ? () => navigate(context, text) : null,
      enabled: enabled,
    );
  }
}

class NavDraver extends StatelessWidget {
  final String? title;

  const NavDraver({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            ExpandableTile(
              header: const ListTile(
                leading: RaxysLogo(
                  opacity: .1,
                  scale: 7,
                ),
                contentPadding: EdgeInsets.only(left: 20),
                title: Text(
                  'Ævzag',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(Icons.send_rounded),
                      ),
                      title: const Text('Developer Contact'),
                      subtitle: const Text('Raxys Studios'),
                      onTap: () => launch('https://t.me/raxysstudios'),
                    ),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        var info = 'Loading...';
                        final package = snapshot.data;
                        if (package != null) {
                          info = [
                            'v' + package.version,
                            'b' + package.buildNumber
                          ].join(' • ');
                        }
                        return ListTile(
                          leading: const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Icon(Icons.code_rounded),
                          ),
                          title: const Text('GitHub Repository'),
                          subtitle: Text(info),
                          onTap: () => launch(
                            'https://github.com/raxysstudios/avzag',
                          ),
                        );
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Editor Mode'),
                      subtitle: Row(
                        children: [
                          if (EditorStore.isEditing) ...[
                            if (EditorStore.isAdmin)
                              const SpanIcon(Icons.account_circle_rounded),
                            Text(capitalize(EditorStore.language)),
                          ] else
                            const Text('Off')
                        ],
                      ),
                      value: EditorStore.language != null,
                      secondary: const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(Icons.edit_rounded),
                      ),
                      onChanged: (e) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  _NavModule(
                    Icons.home_rounded,
                    'home',
                  ).build(context, title),
                  const Divider(),
                  _NavModule(
                    Icons.book_rounded,
                    'dictionary',
                  ).build(context, title),
                  const Divider(),
                  ...[
                    _NavModule(Icons.music_note_rounded, 'phonology'),
                    _NavModule(Icons.switch_left_rounded, 'converter'),
                    _NavModule(Icons.forum_rounded, 'phrasebook'),
                    _NavModule(Icons.local_library_rounded, 'bootcamp'),
                  ].map((t) => t.build(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
