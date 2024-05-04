import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:wolvesrun/pages/NavBarBuilder.dart';
import 'package:wolvesrun/pages/map/map_ui.dart';
import 'package:wolvesrun/pages/settings/setting_ui.dart';

import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      home: Builder(
        builder: (context) {
          return PersistentTabView(
            tabs: [
              PersistentTabConfig(
                screen: Placeholder(),
                item: ItemConfig(
                  icon: Icon(Icons.home),
                  title: "Home",
                ),
              ),
              PersistentTabConfig(
                screen: MapUi(),
                item: ItemConfig(
                  icon: Icon(Icons.map_rounded),
                  title: "Map",
                ),
              ),
              PersistentTabConfig(
                screen: const SettingUi(),
                item: ItemConfig(
                  icon: Icon(Icons.settings),
                  title: S.of(context).settingsTitle,
                ),
              ),
            ],
            navBarBuilder: (navBarConfig) => CustomNavBar(
              navBarConfig: navBarConfig,
              key: const Key("navBar"),
            ),
          );
        }
      ),
    );
  }
}

