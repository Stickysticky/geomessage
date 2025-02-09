import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geomessage/screens/activeMessages/activeMessages.dart';
import 'package:geomessage/screens/createMessage/createMessage.dart';
import 'package:geomessage/screens/home/home.dart';
import 'package:geomessage/screens/sentMessages/sentMessages.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:flutter/services.dart';
import 'package:geomessage/services/messageService.dart';
import 'package:geomessage/services/notificationService.dart';
import 'package:geomessage/tasks/messageTask.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la base de données
  final dbService = DatabaseService();
  final msService = MessageService();
  await dbService.database;


  await NotificationService().init();

  FlutterForegroundTask.initCommunicationPort();
  msService.requestPermissions();
  msService.initializeForegroundTask();

  final messages = await dbService.getMessagesWithoutDate();
  if(messages.isEmpty){
    msService.stopForeGroundProcess();
  } else {
    msService.startForeGroundProcess();
  }

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/message-creation': (context) => CreateMessage(),
      '/active-messages': (context) => ActiveMessages(),
      '/sent-messages': (context) => SentMessages()
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
