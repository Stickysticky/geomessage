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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `GeoMessage`
  String get title {
    return Intl.message('GeoMessage', name: 'title', desc: '', args: []);
  }

  /// `Création d'un message`
  String get createMessage {
    return Intl.message(
      'Création d\'un message',
      name: 'createMessage',
      desc: '',
      args: [],
    );
  }

  /// `Messages actifs`
  String get activeMessage {
    return Intl.message(
      'Messages actifs',
      name: 'activeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Messages envoyés`
  String get sentMessages {
    return Intl.message(
      'Messages envoyés',
      name: 'sentMessages',
      desc: '',
      args: [],
    );
  }

  /// `Veuillez ajouter la localisation pour l'envoie du message`
  String get infoMessagePoint {
    return Intl.message(
      'Veuillez ajouter la localisation pour l\'envoie du message',
      name: 'infoMessagePoint',
      desc: '',
      args: [],
    );
  }

  /// `Gps désactivé`
  String get gpsDisabled {
    return Intl.message(
      'Gps désactivé',
      name: 'gpsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Pour bénéficier de toutes les fonctionnalités de l'application, veuillez activer le GPS`
  String get gpsDisabledInfo {
    return Intl.message(
      'Pour bénéficier de toutes les fonctionnalités de l\'application, veuillez activer le GPS',
      name: 'gpsDisabledInfo',
      desc: '',
      args: [],
    );
  }

  /// `Activer le GPS`
  String get gpsActivation {
    return Intl.message(
      'Activer le GPS',
      name: 'gpsActivation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'en'),
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
