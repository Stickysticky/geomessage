import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/localisationService.dart';
import 'package:geomessage/services/notificationService.dart';

@pragma('vm:entry-point')
class MessageTask extends TaskHandler{
  static const PLATFORM = MethodChannel('com.olivier.ettlin.geomessage/sms');

  LocalisationService _localisationService = LocalisationService();
  DatabaseService _dbService = DatabaseService();
  NotificationService _notificationService = NotificationService();

  Future<void> _sendSms(String message, String phoneNumber) async {
    try {
      final TEST = await PLATFORM.invokeMethod('test');
      print(TEST);
      final result = await PLATFORM.invokeMethod('sendSms', {
        'message': message,
        'phoneNumber': phoneNumber,
      });
      print(result); // Affiche le résultat retourné par Kotlin
    } on PlatformException catch (e) {
      print("Erreur d'envoi du SMS: ${e.message}");
    }
  }

  Future<void> _executeFunction(DateTime timestamp) async {
    if (await _localisationService.checkGps()){
    final messages = await _dbService.getMessagesWithoutDate();


      if(!messages.isEmpty){
        for(var message in messages){
          if(await _localisationService.checkCurrentLocationInRadius(message)){
            print("Dans le rayon");
            try {
              await _sendSms(message.message, message.phoneNumber);
              print("SMS envoyé");
              _notificationService.showNotification(
                  id: timestamp.millisecond,
                  title: 'Message envoyé',
                  body: 'Le message a été envoyé au : ${message.phoneNumber}'
              );
            } catch (error) {
              print(error);
              print("Failed to send sms");
            }

            _dbService.updateMessageWithCurrentDate(message);

          } else {
            print("Hors du rayon");
          }
        }
      } else {
        print("Plus de messages");
        FlutterForegroundTask.stopService();
      }
    }
  }
  @override
  void onRepeatEvent(DateTime timestamp) {
    _executeFunction(timestamp); // Exécute toutes les 5 secondes
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('Foreground task destroyed.');
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _executeFunction(timestamp);
  }
  
}