import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geomessage/screens/activeMessages/activeMessages.dart';
import 'package:geomessage/screens/createMessage/createMessage.dart';
import 'package:geomessage/screens/home/home.dart';
import 'package:geomessage/services/databaseService.dart';

import 'generated/l10n.dart';// Assurez-vous que le chemin vers DatabaseHelper est correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base de données
  final dbService = DatabaseService();
  await dbService.database;  // Cette ligne initialise la base de données et crée la table si nécessaire.

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/message-creation': (context) => CreateMessage(),
      '/active-messages': (context) => ActiveMessages()
    },
    locale: Locale('fr'),
    supportedLocales: [
      Locale('fr', ''),
    ],
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      S.delegate
    ],
    localeResolutionCallback: (locale, supportedLocales) {
      if (locale == null) {
        return Locale('fr');
      }
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return supportedLocale;
        }
      }
      return Locale('fr');
    },
  ));
}
