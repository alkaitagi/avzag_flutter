import 'package:avzag/global_store.dart';
import 'package:flutter/material.dart';
import 'navigation/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<ThemeData> getThemes(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final floatingActionButtonTheme = FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
    const cardTheme = CardTheme(
      clipBehavior: Clip.antiAlias,
    );
    return [
      ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        cardTheme: cardTheme,
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: floatingActionButtonTheme,
      ),
      ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
          brightness: Brightness.dark,
        ),
        cardTheme: cardTheme,
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: floatingActionButtonTheme,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themes = getThemes(context);
    return MaterialApp(
      title: 'Avzag',
      theme: themes[0],
      darkTheme: themes[1],
      home: FutureBuilder(
        future: Future.wait([
          Future.delayed(const Duration(seconds: 1)),
          GlobalStore.load(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            navigate(
              context,
              GlobalStore.prefs.getString('module') ?? 'home',
            );
          }
          return Material(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 256,
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/splash_dark.png'
                            : 'assets/splash_light.png',
                        isAntiAlias: true,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  const Text(
                    'ÆVZAG',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Made with honor in'),
                  const Text(
                    'North Caucasus',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
