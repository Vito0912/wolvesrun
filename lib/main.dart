import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:wolvesrun/pages/NavBarBuilder.dart';
import 'package:wolvesrun/pages/auth/sign_in_ui.dart';
import 'package:wolvesrun/pages/main/run/DetailedRun.dart';
import 'package:wolvesrun/pages/main/run/RunUI.dart';
import 'package:wolvesrun/pages/map/map_ui.dart';
import 'package:wolvesrun/pages/settings/setting_ui.dart';
import 'package:wolvesrun/services/NotifcationService.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/util/MainUtil.dart';
import 'package:wolvesrun/util/Preferences.dart';

import 'generated/l10n.dart';
import 'models/arguments/DetailedRunArguments.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SP sp = SP();


  globals.wolvesRunServer =
      await sp.getString("server") ?? globals.wolvesRunServer;

  globals.useDarkTheme =
      await sp.getBool("useDarkTheme") ?? globals.useDarkTheme;

  globals.token = await sp.getString("token");

  globals.lastRunId = await sp.getInt("lastRunId");

  await NotificationService().requestPermissions();

  globals.hasConnection = await MainUtil.hasInternetConnection();

  if(globals.hasConnection) {
    try {
      globals.user = await MainUtil.retrieveUserInformation();
    } catch (_) {
      globals.hasConnection = false;
    }
  }

  globals.gridSize = await sp.getInt("gridSize") ?? 500;

  await MainUtil.getCachedTileProvider();

  await MainUtil.setAppDocumentDirectory();

  runApp(const ProviderScope(child: MyApp()));
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
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      themeMode: globals.useDarkTheme ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      onGenerateTitle: (BuildContext context) {
        return S.of(context).settingsTitle;
      },
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      initialRoute: "/",
      routes: {
        '/': (context) => Builder(builder: (context) {
          return PersistentTabView(
            tabs: [
              PersistentTabConfig(
                screen: const RunUi(),
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
              navBarDecoration: NavBarDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    )
                  ],
              ),
              key: const Key("navBar"),
            ),
          );
        }),
        '/signIn': (context) => const SignInUi(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == DetailedRun.routeName) {
          final args = settings.arguments as DetailedRunArguments;
          print(args);
          return MaterialPageRoute(
            builder: (context) {
              return DetailedRun(
                args: args,
              );
            },
          );
        }
        return null;
      }
    );
  }
}
