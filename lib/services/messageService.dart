import 'package:flutter/services.dart';
import 'package:geomessage/model/message.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/localisationService.dart';

class MessageService {
  static const backgroundChannel = MethodChannel('com.olivier.ettlin.geomessage/background');
  static Future<void> handleMessagesWithoutDates () async {

    DatabaseService _db = DatabaseService();
    LocalisationService _localisationService = LocalisationService();

    List<Message> messages = await _db.getMessagesWithoutDate();

    print("message service");
    for(var message in messages){
      print(message.libelle);
      if(await _localisationService.checkCurrentLocationInRadius(message)){
        print("message in radius");
      } else {
        print("message not in radius");
      }
    }
  }


// Méthode pour démarrer le processus côté Flutter
  static Future<void> startForegroundProcess() async {
    try {
      // Appeler Kotlin pour démarrer le processus en arrière-plan
      await backgroundChannel.invokeMethod('startForegroundProcess');
    } on PlatformException catch (e) {
      print("Error calling startForegroundService: ${e.message}");
    }
  }
}