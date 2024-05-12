// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message(
      'Settings',
      name: 'settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Common`
  String get commonHeading {
    return Intl.message(
      'Common',
      name: 'commonHeading',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark {
    return Intl.message(
      'Dark Mode',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get light {
    return Intl.message(
      'Light Mode',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Attribution`
  String get attribution {
    return Intl.message(
      'Attribution',
      name: 'attribution',
      desc: '',
      args: [],
    );
  }

  /// `System Informations`
  String get systemInformations {
    return Intl.message(
      'System Informations',
      name: 'systemInformations',
      desc: '',
      args: [],
    );
  }

  /// `This page shows you some informations about your system.`
  String get systemInformationsDesc {
    return Intl.message(
      'This page shows you some informations about your system.',
      name: 'systemInformationsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get author {
    return Intl.message(
      'Author',
      name: 'author',
      desc: '',
      args: [],
    );
  }

  /// `License`
  String get license {
    return Intl.message(
      'License',
      name: 'license',
      desc: '',
      args: [],
    );
  }

  /// `There was an error loading the data.`
  String get errorLoadingData {
    return Intl.message(
      'There was an error loading the data.',
      name: 'errorLoadingData',
      desc: '',
      args: [],
    );
  }

  /// `Server URL`
  String get serverUrl {
    return Intl.message(
      'Server URL',
      name: 'serverUrl',
      desc: '',
      args: [],
    );
  }

  /// `Email/Username`
  String get emailusername {
    return Intl.message(
      'Email/Username',
      name: 'emailusername',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Select your activity`
  String get selectYourActivity {
    return Intl.message(
      'Select your activity',
      name: 'selectYourActivity',
      desc: '',
      args: [],
    );
  }

  /// `The choice of your activity affects the amount of resources generated and their positioning (e.g., bike paths, running paths).`
  String get activitySelectDescription {
    return Intl.message(
      'The choice of your activity affects the amount of resources generated and their positioning (e.g., bike paths, running paths).',
      name: 'activitySelectDescription',
      desc: '',
      args: [],
    );
  }

  /// `Run`
  String get run {
    return Intl.message(
      'Run',
      name: 'run',
      desc: '',
      args: [],
    );
  }

  /// `Walk`
  String get walk {
    return Intl.message(
      'Walk',
      name: 'walk',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get bike {
    return Intl.message(
      'Bike',
      name: 'bike',
      desc: '',
      args: [],
    );
  }

  /// `Select difficulty`
  String get selectDifficulty {
    return Intl.message(
      'Select difficulty',
      name: 'selectDifficulty',
      desc: '',
      args: [],
    );
  }

  /// `The selection of difficulty affects the number and challenge of events, as well as the amount of items lost. Higher difficulties result in better items spawning.`
  String get selectDifficultyDescription {
    return Intl.message(
      'The selection of difficulty affects the number and challenge of events, as well as the amount of items lost. Higher difficulties result in better items spawning.',
      name: 'selectDifficultyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Easy`
  String get easy {
    return Intl.message(
      'Easy',
      name: 'easy',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message(
      'Medium',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `Hard`
  String get hard {
    return Intl.message(
      'Hard',
      name: 'hard',
      desc: '',
      args: [],
    );
  }

  /// `Keep items`
  String get keepItems {
    return Intl.message(
      'Keep items',
      name: 'keepItems',
      desc: '',
      args: [],
    );
  }

  /// `During events, items can be lost, for example, if one is too slow. This setting prevents the loss of items but does not deactivate the events.`
  String get keepItemsDescription {
    return Intl.message(
      'During events, items can be lost, for example, if one is too slow. This setting prevents the loss of items but does not deactivate the events.',
      name: 'keepItemsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Disable Events`
  String get disableEvents {
    return Intl.message(
      'Disable Events',
      name: 'disableEvents',
      desc: '',
      args: [],
    );
  }

  /// `Disables events. The difficulty is not affected by this. However, rewards from successful events are disabled.`
  String get disableEventsDescription {
    return Intl.message(
      'Disables events. The difficulty is not affected by this. However, rewards from successful events are disabled.',
      name: 'disableEventsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Precision`
  String get precision {
    return Intl.message(
      'Precision',
      name: 'precision',
      desc: '',
      args: [],
    );
  }

  /// `Defines the precision of the recorded path. More precision means means higher battery consumption.`
  String get precisionDescription {
    return Intl.message(
      'Defines the precision of the recorded path. More precision means means higher battery consumption.',
      name: 'precisionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Battery saving`
  String get batterySaving {
    return Intl.message(
      'Battery saving',
      name: 'batterySaving',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message(
      'Low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get balanced {
    return Intl.message(
      'Balanced',
      name: 'balanced',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get high {
    return Intl.message(
      'High',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `If you choose this setting, the recording quality will be very poor. This is particularly true for fast activities, which may result in curves being cut and items possibly not being collected properly. Choose this setting only if you want to collect items, but do not intend to use the track for accurate results.`
  String get batterySavingInformation {
    return Intl.message(
      'If you choose this setting, the recording quality will be very poor. This is particularly true for fast activities, which may result in curves being cut and items possibly not being collected properly. Choose this setting only if you want to collect items, but do not intend to use the track for accurate results.',
      name: 'batterySavingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Use it anyway`
  String get useItAnyway {
    return Intl.message(
      'Use it anyway',
      name: 'useItAnyway',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get unauthorized {
    return Intl.message(
      'Unauthorized',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `WolvesRun is recording your location.`
  String get wolvesrunIsRecordingYourLocation {
    return Intl.message(
      'WolvesRun is recording your location.',
      name: 'wolvesrunIsRecordingYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `WolvesRun - Recording`
  String get wolvesrunRecording {
    return Intl.message(
      'WolvesRun - Recording',
      name: 'wolvesrunRecording',
      desc: '',
      args: [],
    );
  }

  /// `Position Update`
  String get positionUpdate {
    return Intl.message(
      'Position Update',
      name: 'positionUpdate',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
