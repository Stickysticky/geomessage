import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geomessage/screens/activeMessages/activeMessages.dart';
import 'package:geomessage/screens/createMessage/createMessage.dart';
import 'package:geomessage/screens/home/home.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:flutter/services.dart'; // Import pour le MethodChannel

import 'generated/l10n.dart'; // Assurez-vous que le chemin vers DatabaseHelper est correct

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base de données
  final dbService = DatabaseService();
  await dbService.database;  // Cette ligne initialise la base de données et crée la table si nécessaire.

  // Appeler le code natif pour démarrer la tâche en arrière-plan
  final messages = await dbService.getMessagesWithoutDate();

  if(messages.isEmpty){
    stopBackgroundProcess();
  } else {
    startBackgroundProcess();
  }


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

// Canal de plateforme pour appeler le code natif Kotlin
const platform = MethodChannel('com.olivier.ettlin.geomessage/background');

// Fonction pour démarrer la tâche en arrière-plan via Kotlin
Future<void> startBackgroundProcess() async {
  try {
    await platform.invokeMethod('startBackgroundProcess');
  } on PlatformException catch (e) {
    print("Erreur lors de l'appel au code natif : ${e.message}");
  }
}
// Fonction pour démarrer la tâche en arrière-plan via Kotlin
Future<void> stopBackgroundProcess() async {
  try {
    await platform.invokeMethod('stopBackgroundProcess');
  } on PlatformException catch (e) {
    print("Erreur lors de l'appel au code natif : ${e.message}");
  }
}
