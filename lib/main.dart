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
  await dbService.database;


  await NotificationService().init();

  FlutterForegroundTask.initCommunicationPort();
  initializeForegroundTask();

  final messages = await dbService.getMessagesWithoutDate();
  if(messages.isEmpty){
    //stopBackgroundProcess();
    MessageService.stopForeGroundProcess();
  } else {
    //startBackgroundProcess();
    await MessageService.requestPermissions();
    await MessageService.startForeGroundProcess();
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

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MessageTask());
}

void initializeForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription:
      'This notification appears when the foreground service is running.',
      onlyAlertOnce: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

