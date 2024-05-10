import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:wolvesrun/pages/NavBarBuilder.dart';
import 'package:wolvesrun/pages/auth/sign_in_ui.dart';
import 'package:wolvesrun/pages/map/map_ui.dart';
import 'package:wolvesrun/pages/settings/setting_ui.dart';
import 'package:wolvesrun/services/NotifcationService.dart';
import 'package:wolvesrun/globals.dart' as globals;
import 'package:wolvesrun/util/MainUtil.dart';
import 'package:wolvesrun/util/Preferences.dart';

import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SP sp = SP();

  globals.wolvesRunServer =
      await sp.getString("server") ?? globals.wolvesRunServer;

  globals.useDarkTheme =
      await sp.getBool("useDarkTheme") ?? globals.useDarkTheme;

  globals.token = await sp.getString("token");

  await NotificationService().requestPermissions();

  globals.hasConnection = await MainUtil.hasInternetConnection();

  if(globals.hasConnection) {
    globals.user = await MainUtil.retrieveUserInformation();
  }

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
        BackgroundLocation.setAndroidNotification(
          title: S.current.settingsTitle,
          message: "Notification message",
          icon: "@mipmap/ic_launcher",
        );

        BackgroundLocation.setAndroidConfiguration(3000);
        BackgroundLocation.startLocationService();

        return S.of(context).settingsTitle;
      },
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      initialRoute: "/",
      routes: {
        '/': (context) => Builder(builder: (context) {
          return PersistentTabView(
            tabs: [
              PersistentTabConfig(
                screen: SignInUi(),
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
    );
  }
}
