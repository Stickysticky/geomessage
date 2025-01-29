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

  /// `messages envoyés`
  String get sentMessages {
    return Intl.message(
      'messages envoyés',
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

  /// `message`
  String get message {
    return Intl.message('message', name: 'message', desc: '', args: []);
  }

  /// `numéro de téléphone`
  String get phoneNumber {
    return Intl.message(
      'numéro de téléphone',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Libellé`
  String get libelle {
    return Intl.message('Libellé', name: 'libelle', desc: '', args: []);
  }

  /// `The message is required`
  String get messageRequired {
    return Intl.message(
      'The message is required',
      name: 'messageRequired',
      desc: '',
      args: [],
    );
  }

  /// `Numéro de téléphone requis.`
  String get phoneNumberRequired {
    return Intl.message(
      'Numéro de téléphone requis.',
      name: 'phoneNumberRequired',
      desc: '',
      args: [],
    );
  }

  /// `radius`
  String get rayon {
    return Intl.message('radius', name: 'rayon', desc: '', args: []);
  }

  /// `Le rayon est requis.`
  String get radiusRequired {
    return Intl.message(
      'Le rayon est requis.',
      name: 'radiusRequired',
      desc: '',
      args: [],
    );
  }

  /// `Veuillez entrer un rayon valide.`
  String get validRadius {
    return Intl.message(
      'Veuillez entrer un rayon valide.',
      name: 'validRadius',
      desc: '',
      args: [],
    );
  }

  /// `Valider`
  String get validate {
    return Intl.message('Valider', name: 'validate', desc: '', args: []);
  }

  /// `Annuler`
  String get cancel {
    return Intl.message('Annuler', name: 'cancel', desc: '', args: []);
  }

  /// `Le message a été créé`
  String get messageCreated {
    return Intl.message(
      'Le message a été créé',
      name: 'messageCreated',
      desc: '',
      args: [],
    );
  }

  /// `Erreur`
  String get error {
    return Intl.message('Erreur', name: 'error', desc: '', args: []);
  }

  /// `Il n'y a aucun message actif.`
  String get noActiveMessages {
    return Intl.message(
      'Il n\'y a aucun message actif.',
      name: 'noActiveMessages',
      desc: '',
      args: [],
    );
  }

  /// `confirmation`
  String get confirmation {
    return Intl.message(
      'confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Êtes-vous sûr de vouloir supprimer ce message ?`
  String get deleteMessageConfirmation {
    return Intl.message(
      'Êtes-vous sûr de vouloir supprimer ce message ?',
      name: 'deleteMessageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Le message a été supprimé`
  String get deletedMessage {
    return Intl.message(
      'Le message a été supprimé',
      name: 'deletedMessage',
      desc: '',
      args: [],
    );
  }

  /// `supprimer`
  String get delete {
    return Intl.message('supprimer', name: 'delete', desc: '', args: []);
  }

  /// `aucun messages envoyés`
  String get noSentMessages {
    return Intl.message(
      'aucun messages envoyés',
      name: 'noSentMessages',
      desc: '',
      args: [],
    );
  }

  /// `envoyé le `
  String get sentAt {
    return Intl.message('envoyé le ', name: 'sentAt', desc: '', args: []);
  }

  /// `destinataire :`
  String get receiver {
    return Intl.message('destinataire :', name: 'receiver', desc: '', args: []);
  }

  /// `date d'envoie`
  String get sendingDate {
    return Intl.message(
      'date d\'envoie',
      name: 'sendingDate',
      desc: '',
      args: [],
    );
  }

  /// `restaurer`
  String get restore {
    return Intl.message('restaurer', name: 'restore', desc: '', args: []);
  }

  /// `Êtes-vous sûr de vouloir restaurer ce message ?`
  String get restoreMessageConfirmation {
    return Intl.message(
      'Êtes-vous sûr de vouloir restaurer ce message ?',
      name: 'restoreMessageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Le message a été restauré`
  String get restoredMessage {
    return Intl.message(
      'Le message a été restauré',
      name: 'restoredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Voulez vous supprimer tout les messages envoyés? Les messages non envoyés ne seront pas affectés.`
  String get deleteAllSentMessageConfirmation {
    return Intl.message(
      'Voulez vous supprimer tout les messages envoyés? Les messages non envoyés ne seront pas affectés.',
      name: 'deleteAllSentMessageConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Les messages envoyé ont été supprimé`
  String get deletedAllSentMessage {
    return Intl.message(
      'Les messages envoyé ont été supprimé',
      name: 'deletedAllSentMessage',
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
