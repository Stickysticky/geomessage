import 'package:flutter_foreground_task/flutter_foreground_task.dart';
//import 'package:flutter_sms/flutter_sms.dart';
import 'package:geomessage/services/databaseService.dart';
import 'package:geomessage/services/localisationService.dart';
import 'package:geomessage/services/notificationService.dart';

@pragma('vm:entry-point')
class MessageTask extends TaskHandler{
  LocalisationService _localisationService = LocalisationService();
  DatabaseService _dbService = DatabaseService();
  NotificationService _notificationService = NotificationService();

  Future<void> _executeFunction(DateTime timestamp) async {
    if (await _localisationService.checkGps()){
    final messages = await _dbService.getMessagesWithoutDate();


      if(!messages.isEmpty){
        for(var message in messages){
          if(await _localisationService.checkCurrentLocationInRadius(message)){
            print("Dans le rayon");
            try {
              /*await sendSMS(
                message: message.message,
                recipients: [message.phoneNumber],
              );*/
              print("SMS sent");
              _notificationService.showNotification(
                  id: timestamp.millisecond,
                  title: 'Message envoyé',
                  body: 'Le message a été envoyé à:'
              );
            } catch (error) {
              print("Failed to send sms");
            }

            _dbService.updateMessageWithCurrentDate(message);

          } else {
            print("Hors du rayon");
          }
        }
      } else {
        print("Plus de messages");
        onDestroy(timestamp);
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
    print('Foreground task started.');
    _executeFunction(timestamp);
  }
  
}